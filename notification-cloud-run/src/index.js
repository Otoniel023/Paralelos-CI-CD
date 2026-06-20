require('dotenv').config();
const express = require('express');
const { sendEmail } = require('./services/emailService');

const app = express();
app.use(express.json());

const log = (severity, message, extra = {}) => {
  console.log(JSON.stringify({ severity, message, ...extra, timestamp: new Date().toISOString() }));
};

app.get('/health', (_, res) => {
  res.json({ status: 'ok', service: 'notification-cloud-run' });
});

app.post('/pubsub', async (req, res) => {
  const envelope = req.body;

  if (!envelope?.message?.data) {
    log('WARNING', 'Mensaje Pub/Sub sin data', { envelope });
    return res.status(400).json({ error: 'Mensaje inválido: falta data' });
  }

  let payload;
  try {
    const decoded = Buffer.from(envelope.message.data, 'base64').toString('utf8');
    payload = JSON.parse(decoded);
  } catch {
    log('ERROR', 'Error al decodificar mensaje Pub/Sub');
    return res.status(400).json({ error: 'Data inválida' });
  }

  const { email, subject, message } = payload;

  if (!email || !subject || !message) {
    log('WARNING', 'Payload incompleto', { payload });
    return res.status(400).json({ error: 'Faltan campos: email, subject, message' });
  }

  try {
    log('INFO', 'Procesando notificación', { email, subject });

    const result = await sendEmail({ email, subject, message });

    log('INFO', 'Correo enviado exitosamente', { email, subject, resendId: result?.id });

    return res.status(200).json({ success: true, id: result?.id });
  } catch (err) {
    log('ERROR', 'Error al enviar correo', { email, error: err.message });
    return res.status(500).json({ error: 'Error al enviar correo' });
  }
});

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  log('INFO', `notification-cloud-run corriendo en puerto ${PORT}`);
});
