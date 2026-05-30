const CreateUser = require('../../../application/user/CreateUser');
const GetUser    = require('../../../application/user/GetUser');
const UpdateUser = require('../../../application/user/UpdateUser');
const DeleteUser = require('../../../application/user/DeleteUser');
const LoginUser  = require('../../../application/user/LoginUser');

class UserController {
  constructor(userRepository) {
    this.createUser = new CreateUser(userRepository);
    this.getUser    = new GetUser(userRepository);
    this.updateUser = new UpdateUser(userRepository);
    this.deleteUser = new DeleteUser(userRepository);
    this.loginUser  = new LoginUser(userRepository);
  }

  async login(req, res) {
    try {
      const result = await this.loginUser.execute(req.body);
      res.json(result);
    } catch (e) {
      res.status(401).json({ error: e.message });
    }
  }

  async getAll(req, res) {
    try {
      const users = await this.getUser.getAll();
      res.json(users);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  }

  async getById(req, res) {
    try {
      const user = await this.getUser.getById(Number(req.params.id));
      res.json(user);
    } catch (e) {
      res.status(404).json({ error: e.message });
    }
  }

  async create(req, res) {
    try {
      const user = await this.createUser.execute(req.body);
      res.status(201).json(user);
    } catch (e) {
      res.status(400).json({ error: e.message });
    }
  }

  async update(req, res) {
    try {
      const user = await this.updateUser.execute(Number(req.params.id), req.body);
      res.json(user);
    } catch (e) {
      res.status(400).json({ error: e.message });
    }
  }

  async delete(req, res) {
    try {
      const result = await this.deleteUser.execute(Number(req.params.id));
      res.json(result);
    } catch (e) {
      res.status(404).json({ error: e.message });
    }
  }
}

module.exports = UserController;
