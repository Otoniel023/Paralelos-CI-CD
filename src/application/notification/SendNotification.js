const { PubSub } = require('@google-cloud/pubsub');

const pubsub = new PubSub({ projectId: process.env.GCP_PROJECT_ID });

class SendNotification {
  async execute({ email, subject, message }) {
    if (!email || !subject || !message) {
      throw new Error('Faltan campos requeridos: email, subject, message');
    }

    const topicName = process.env.PUBSUB_TOPIC || 'paralelos-api-notifications';
    const payload = Buffer.from(JSON.stringify({ email, subject, message }));

    const messageId = await pubsub.topic(topicName).publish(payload);
    return { messageId };
  }
}

module.exports = SendNotification;
