const { Resend } = require('resend');

const resend = new Resend(process.env.RESEND_API_KEY);

const FROM_EMAIL = process.env.FROM_EMAIL || 'notificaciones@paralelos.dev';

async function sendEmail({ email, subject, message }) {
  const { data, error } = await resend.emails.send({
    from: FROM_EMAIL,
    to: email,
    subject,
    html: `
      <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
        <h2 style="color: #333;">${subject}</h2>
        <p style="color: #555; line-height: 1.6;">${message}</p>
        <hr style="border: none; border-top: 1px solid #eee; margin: 24px 0;">
        <p style="color: #999; font-size: 12px;">Enviado desde Paralelos GCP Serverless</p>
      </div>
    `,
  });

  if (error) throw new Error(error.message);

  return data;
}

module.exports = { sendEmail };
