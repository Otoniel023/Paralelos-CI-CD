import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/api_constants.dart';
import 'upload_viewmodel.dart';

class UploadView extends StatefulWidget {
  const UploadView({super.key});

  @override
  State<UploadView> createState() => _UploadViewState();
}

class _UploadViewState extends State<UploadView> {
  String? _selectedPath;
  String? _selectedName;

  bool get _isImage {
    if (_selectedName == null) return false;
    final ext = _selectedName!.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(ext);
  }

  Future<void> _pickFile(UploadViewModel vm) async {
    vm.reset();
    setState(() {
      _selectedPath = null;
      _selectedName = null;
    });
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'webp', 'pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedPath = result.files.single.path;
        _selectedName = result.files.single.name;
      });
    }
  }

  Future<void> _upload(UploadViewModel vm) async {
    if (_selectedPath == null) return;
    await vm.upload(_selectedPath!);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UploadViewModel(),
      child: Consumer<UploadViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Subir archivo'),
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Selecciona una imagen o PDF (máx. 5MB)',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  // Preview local ANTES de subir
                  GestureDetector(
                    onTap: vm.isLoading ? null : () => _pickFile(vm),
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.indigo.shade200, width: 2),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.indigo.shade50,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: _selectedPath != null && _isImage
                          ? Image.file(
                              File(_selectedPath!),
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _selectedName != null
                                      ? Icons.picture_as_pdf
                                      : Icons.cloud_upload_outlined,
                                  size: 52,
                                  color: Colors.indigo,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _selectedName ?? 'Toca para seleccionar',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: _selectedName != null
                                        ? Colors.indigo.shade700
                                        : Colors.grey,
                                    fontWeight: _selectedName != null
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  if (_selectedPath != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        _selectedName!,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Botón subir
                  SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: (vm.isLoading || _selectedPath == null)
                          ? null
                          : () => _upload(vm),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                      icon: vm.isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.upload),
                      label: Text(vm.isLoading ? 'Subiendo...' : 'Subir archivo'),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Resultado: imagen cargada desde la URL del servidor
                  if (vm.state == UploadState.success && vm.uploadedUrl != null) ...[
                    const Divider(),
                    const SizedBox(height: 12),
                    const Text(
                      'Imagen en el servidor:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        '${ApiConstants.baseUrl}/uploads/${vm.uploadedFilename}',
                        fit: BoxFit.cover,
                        height: 220,
                        width: double.infinity,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return SizedBox(
                            height: 220,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: progress.expectedTotalBytes != null
                                    ? progress.cumulativeBytesLoaded /
                                        progress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stack) => Container(
                          height: 100,
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Text('No se pudo cargar la imagen'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 18),
                        const SizedBox(width: 6),
                        Expanded(
                          child: SelectableText(
                            vm.uploadedUrl!,
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ],

                  if (vm.error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        vm.error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
