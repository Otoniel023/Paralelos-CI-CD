const SendNotification = require('../../../application/notification/SendNotification');

class NotificationController {
  constructor() {
    this.sendNotification = new SendNotification();
  }

  async send(req, res) {
    try {
      const { email, subject, message } = req.body;
      const result = await this.sendNotification.execute({ email, subject, message });
      res.json({ success: true, messageId: result.messageId });
    } catch (e) {
      res.status(400).json({ error: e.message });
    }
  }
}

module.exports = NotificationController;
