import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/category_service.dart';

class AdminCategoryManager extends StatefulWidget {
  const AdminCategoryManager({Key? key}) : super(key: key);

  @override
  State<AdminCategoryManager> createState() => _AdminCategoryManagerState();
}

class _AdminCategoryManagerState extends State<AdminCategoryManager> {
  List<Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    setState(() => _isLoading = true);
    final categories = CategoryService.getAllCategories();
    setState(() {
      _categories = categories;
      _isLoading = false;
    });
  }

  void _showCategoryForm({Category? category}) async {
    final result = await showDialog<Category>(
      context: context,
      builder: (context) => _CategoryFormDialog(category: category),
    );
    if (result != null) {
      await _fetchCategories();
    }
  }

  void _deleteCategory(Category category) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận'),
        content: Text('Bạn có chắc muốn xóa danh mục "${category.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xóa', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm == true) {
      CategoryService.deleteCategory(category.id);
      await _fetchCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _categories.isEmpty
              ? const Center(child: Text('Chưa có danh mục nào.'))
              : ListView.builder(
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return ListTile(
                      leading: category.imageUrl.isNotEmpty
                          ? Image.network(category.imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                          : const Icon(Icons.category),
                      title: Text(category.name),
                      subtitle: Text(category.description),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch(
                            value: category.isActive,
                            onChanged: (value) {
                              final updatedCategory = category.copyWith(isActive: value);
                              CategoryService.updateCategory(updatedCategory);
                              _fetchCategories();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showCategoryForm(category: category),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteCategory(category),
                          ),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryForm(),
        child: const Icon(Icons.add),
        tooltip: 'Thêm danh mục',
      ),
    );
  }
}

class _CategoryFormDialog extends StatefulWidget {
  final Category? category;
  const _CategoryFormDialog({this.category});

  @override
  State<_CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<_CategoryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageUrlController;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _descriptionController = TextEditingController(text: widget.category?.description ?? '');
    _imageUrlController = TextEditingController(text: widget.category?.imageUrl ?? '');
    _isActive = widget.category?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final category = Category(
        id: widget.category?.id ?? '',
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
        isActive: _isActive,
      );
      if (widget.category == null) {
        CategoryService.addCategory(category);
      } else {
        CategoryService.updateCategory(category);
      }
      if (mounted) Navigator.pop(context, category);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.category == null ? 'Thêm danh mục' : 'Sửa danh mục'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Tên danh mục'),
                validator: (value) => value == null || value.isEmpty ? 'Nhập tên danh mục' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Mô tả'),
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Link ảnh'),
              ),
              SwitchListTile(
                title: const Text('Trạng thái'),
                subtitle: Text(_isActive ? 'Đang hoạt động' : 'Không hoạt động'),
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
        ElevatedButton(onPressed: _submit, child: const Text('Lưu')),
      ],
    );
  }
} 