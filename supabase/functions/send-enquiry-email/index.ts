// Supabase Edge Function: send-enquiry-email
// Sends the traveller a confirmation email after an enquiry is submitted.
// Uses Resend (https://resend.com) — set RESEND_API_KEY and MAIL_FROM as
// function secrets:
//   supabase secrets set RESEND_API_KEY=re_xxx MAIL_FROM="Aurevia <concierge@aurevia.travel>"
// Deploy with:
//   supabase functions deploy send-enquiry-email

Deno.serve(async (req: Request): Promise<Response> => {
  const cors = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers":
      "authorization, x-client-info, apikey, content-type",
  };
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: cors });
  }

  try {
    const { email, name } = (await req.json()) as {
      email?: string;
      name?: string;
    };
    if (!email || !email.includes("@")) {
      return new Response(JSON.stringify({ error: "Valid email required" }), {
        status: 400,
        headers: { ...cors, "Content-Type": "application/json" },
      });
    }

    const apiKey = Deno.env.get("RESEND_API_KEY");
    const from = Deno.env.get("MAIL_FROM") ??
      "Aurevia <concierge@aurevia.travel>";
    if (!apiKey) {
      return new Response(
        JSON.stringify({ error: "RESEND_API_KEY not configured" }),
        { status: 500, headers: { ...cors, "Content-Type": "application/json" } },
      );
    }

    const firstName = (name ?? "traveller").split(" ")[0];
    const html = `
      <div style="background:#060F1B;padding:48px 24px;font-family:Georgia,serif">
        <div style="max-width:560px;margin:0 auto;background:#FAF8F4;padding:48px">
          <p style="letter-spacing:6px;font-size:14px;color:#0A1B2E;margin:0">AUREVIA<span style="color:#C9A227"> ·</span></p>
          <h1 style="font-weight:300;font-size:28px;color:#0B1626;margin:28px 0 16px">
            Consider it begun, ${firstName}.
          </h1>
          <p style="color:#2A3648;line-height:1.7;font-size:15px">
            Your enquiry has reached our travel designers. One of them is already
            reading it with a map open. Expect a call or a thoughtfully written
            email within one working day.
          </p>
          <p style="color:#2A3648;line-height:1.7;font-size:15px">
            Until then — start imagining. That part is entirely yours.
          </p>
          <p style="color:#64748B;font-size:13px;margin-top:36px">
            The concierge desk · concierge@aurevia.travel · +91 98470 12345
          </p>
        </div>
      </div>`;

    const res = await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${apiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        from,
        to: [email],
        subject: "Your Aurevia enquiry — consider it begun",
        html,
      }),
    });

    if (!res.ok) {
      const detail = await res.text();
      return new Response(JSON.stringify({ error: "Send failed", detail }), {
        status: 502,
        headers: { ...cors, "Content-Type": "application/json" },
      });
    }

    return new Response(JSON.stringify({ ok: true }), {
      headers: { ...cors, "Content-Type": "application/json" },
    });
  } catch (e) {
    return new Response(JSON.stringify({ error: String(e) }), {
      status: 500,
      headers: { ...cors, "Content-Type": "application/json" },
    });
  }
});
