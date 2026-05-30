class GetUser {
  constructor(userRepository) {
    this.userRepository = userRepository;
  }

  async getAll() {
    const users = await this.userRepository.findAll();
    return users.map(u => u.toPublic());
  }

  async getById(id) {
    const user = await this.userRepository.findById(id);
    if (!user) throw new Error('Usuario no encontrado');
    return user.toPublic();
  }
}

module.exports = GetUser;
