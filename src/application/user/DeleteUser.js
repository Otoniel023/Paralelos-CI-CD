class DeleteUser {
  constructor(userRepository) {
    this.userRepository = userRepository;
  }

  async execute(id) {
    const existing = await this.userRepository.findById(id);
    if (!existing) throw new Error('Usuario no encontrado');
    await this.userRepository.delete(id);
    return { message: 'Usuario eliminado correctamente' };
  }
}

module.exports = DeleteUser;
