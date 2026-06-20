const { Router } = require('express');
const NotificationController = require('../controllers/NotificationController');
const { authMiddleware } = require('../middlewares/authMiddleware');

const router = Router();
const controller = new NotificationController();

router.post('/send', authMiddleware, (req, res) => controller.send(req, res));

module.exports = router;
