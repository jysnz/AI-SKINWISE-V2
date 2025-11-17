import { serve } from "std/http/server.ts";

console.log("send-otp function initialized");

serve(async (req) => {
  // 1. Get secrets from environment
  const accountSid = Deno.env.get("TWILIO_ACCOUNT_SID");
  const authToken = Deno.env.get("TWILIO_AUTH_TOKEN");
  const serviceSid = Deno.env.get("TWILIO_VERIFY_SERVICE_SID");

  if (!accountSid || !authToken || !serviceSid) {
    return new Response(
      JSON.stringify({ error: "Twilio credentials are not set in environment" }),
      { status: 500, headers: { "Content-Type": "application/json" } },
    )
  }

  // 2. Get the request body from the app
  const { to, channel } = await req.json();

  if (!to || !channel) {
    return new Response(
      JSON.stringify({ error: "Missing 'to' or 'channel'" }),
      { status: 400, headers: { "Content-Type": "application/json" } },
    )
  }
  
  try {
    // 3. Call Twilio Verify REST API directly (no SDK)
    const url = `https://verify.twilio.com/v2/Services/${serviceSid}/Verifications`;
    const auth = `Basic ${btoa(`${accountSid}:${authToken}`)}`;

    const params = new URLSearchParams();
    params.append("To", to);
    params.append("Channel", channel);

    const resp = await fetch(url, {
      method: "POST",
      headers: {
        "Authorization": auth,
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: params.toString(),
    });

    const data = await resp.json().catch(() => ({}));

    if (!resp.ok) {
      return new Response(JSON.stringify({ error: data.message || data }), { status: resp.status, headers: { "Content-Type": "application/json" } });
    }

    return new Response(JSON.stringify({ status: data.status || "pending", data }), { status: 200, headers: { "Content-Type": "application/json" } });
  } catch (e) {
    return new Response(
      JSON.stringify({ error: (e as Error).message }),
      { status: 500, headers: { "Content-Type": "application/json" } },
    )
  }
})