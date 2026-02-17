import 'dart:typed_data'; // Untuk Uint8List (Bytes)
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../utils/theme.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();

  // GANTI: Tidak pakai File, tapi pakai Uint8List (Bytes) biar aman di Desktop
  Uint8List? _imageBytes;
  String? _imageExtension; // Simpan ekstensi file (jpg/png)
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  // Fungsi Pilih Gambar (Diubah jadi baca Bytes)
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        // Baca file sebagai Bytes (Data Mentah)
        final bytes = await pickedFile.readAsBytes();
        final ext =
            pickedFile.name.split('.').last; // Ambil ekstensinya (jpg/png)

        setState(() {
          _imageBytes = bytes;
          _imageExtension = ext;
        });
      }
    } catch (e) {
      debugPrint('Error pick image: $e');
    }
  }

  // Fungsi Upload Binary (Lebih stabil untuk Desktop/Web)
  Future<String?> _uploadImageBytes(Uint8List bytes) async {
    try {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}.${_imageExtension ?? "jpg"}';
      final path = 'uploads/$fileName';

      // Tentukan Mime Type
      final mimeType = _imageExtension == 'png' ? 'image/png' : 'image/jpeg';

      // PENTING: Pakai uploadBinary, bukan upload biasa
      await Supabase.instance.client.storage
          .from('product-images')
          .uploadBinary(
            path,
            bytes,
            fileOptions: FileOptions(
              contentType: mimeType,
              upsert: true,
            ),
          );

      // Ambil Link Public
      final imageUrl = Supabase.instance.client.storage
          .from('product-images')
          .getPublicUrl(path);

      return imageUrl;
    } catch (e) {
      debugPrint('Error upload: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Gagal Upload: $e'), backgroundColor: Colors.red),
        );
      }
      return null;
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    if (_imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Harap pilih gambar produk!'),
            backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Upload Gambar (Pakai fungsi baru yg Binary)
      final imageUrl = await _uploadImageBytes(_imageBytes!);

      if (imageUrl == null) throw Exception("Gagal mengupload gambar");

      // 2. Simpan Data ke Database
      await Supabase.instance.client.from('products').insert({
        'name': _nameController.text,
        'price': int.parse(_priceController.text),
        'stock': int.parse(_stockController.text),
        'description': _descriptionController.text,
        'category': _categoryController.text.isEmpty
            ? 'Umum'
            : _categoryController.text,
        'image_url': imageUrl,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Produk berhasil disimpan!'),
              backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Produk Baru",
            style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AREA GAMBAR
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                      image: _imageBytes != null
                          ? DecorationImage(
                              // GANTI: Pakai Image.memory untuk Bytes
                              image: MemoryImage(_imageBytes!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _imageBytes == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.add_a_photo,
                                  size: 50, color: Colors.grey),
                              SizedBox(height: 8),
                              Text("Ketuk untuk upload gambar",
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              _buildTextField("Nama Produk", _nameController),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                      child: _buildTextField("Harga (Rp)", _priceController,
                          isNumber: true)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _buildTextField("Stok", _stockController,
                          isNumber: true)),
                ],
              ),
              const SizedBox(height: 12),

              _buildTextField(
                  "Kategori (Misal: Genteng, Bata)", _categoryController),
              const SizedBox(height: 12),

              _buildTextField("Deskripsi", _descriptionController, maxLines: 3),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _isLoading ? null : _saveProduct,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("SIMPAN PRODUK",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isNumber = false, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label tidak boleh kosong';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
