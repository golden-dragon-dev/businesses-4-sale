import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:businesses_4_sale/constants/business_types.dart';
import 'package:businesses_4_sale/data/listing_repository.dart';
import 'package:businesses_4_sale/models/business_listing.dart';
import 'package:businesses_4_sale/services/platform_guard.dart';
import 'package:businesses_4_sale/theme/app_theme.dart';
import 'package:businesses_4_sale/widgets/ad_banner.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({
    super.key,
    this.showAdBanner = true,
    this.embedded = false,
  });

  final bool showAdBanner;
  final bool embedded;

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final _draft = ListingDraft();
  final _picker = ImagePicker();
  bool _submitting = false;
  Uint8List? _photoPreview;

  Future<void> _pickPhoto() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1280,
      imageQuality: 70,
    );
    if (file == null) return;
    final bytes = await file.readAsBytes();
    setState(() {
      _photoPreview = bytes;
      _draft.localPhotoBytes = bytes;
      _draft.localPhotoPath = file.path;
    });
  }

  Future<void> _submit() async {
    if (!PlatformGuard.canSubmitListing) {
      _showMessage(PlatformGuard.blockedMessage);
      return;
    }

    final error = _draft.validate();
    if (error != null) {
      _showMessage(error);
      return;
    }

    setState(() => _submitting = true);
    try {
      final repo = context.read<ListingRepository>();
      await repo.create(
        draft: _draft,
        photoBytes: _draft.localPhotoBytes == null
            ? null
            : Uint8List.fromList(_draft.localPhotoBytes!),
        photoFileName: 'listing.jpg',
      );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Submitted'),
          content: const Text(
            'Your business has been submitted successfully. '
            'It will appear in the app shortly.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      _showMessage(e.toString());
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _selectBusinessType() async {
    final selected = await showModalBottomSheet<BusinessType>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.75,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Type of Business',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  itemCount: BusinessTypes.all.length,
                  itemBuilder: (context, index) {
                    final type = BusinessTypes.all[index];
                    return ListTile(
                      title: Text(type.label),
                      onTap: () => Navigator.of(context).pop(type),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
    if (selected != null) {
      setState(() => _draft.businessType = selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final blocked = !PlatformGuard.canSubmitListing;

    return Scaffold(
      appBar: widget.embedded
          ? null
          : AppBar(title: const Text('JOIN (List your Business)')),
      body: Column(
        children: [
          if (widget.embedded)
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'JOIN (List your Business)',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          if (widget.showAdBanner) const AdBanner(),
          if (blocked)
            MaterialBanner(
              content: Text(PlatformGuard.blockedMessage),
              actions: [
                TextButton(
                  onPressed: () =>
                      ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
                  child: const Text('OK'),
                ),
              ],
            ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: '1. Name of Company',
                  ),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (value) => _draft.companyName = value,
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: _selectBusinessType,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: '2. Type of Business',
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    child: Text(
                      _draft.businessType?.label ?? 'Select type (01–60)',
                      style: TextStyle(
                        color: _draft.businessType == null
                            ? AppColors.grey
                            : AppColors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(labelText: '3. Location'),
                  maxLines: 2,
                  textCapitalization: TextCapitalization.words,
                  onChanged: (value) => _draft.location = value,
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(
                    labelText: '4. Contact Name',
                    hintText: 'e.g. Mr A / Ms B',
                  ),
                  onChanged: (value) => _draft.contactName = value,
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(
                    labelText: '5a. Contact No. (mobile)',
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (value) => _draft.contactPhone = value,
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(
                    labelText: '5b. Email (optional if phone entered)',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => _draft.contactEmail = value,
                ),
                const SizedBox(height: 12),
                const Text(
                  '6. Photo (optional — one only, under 500 KB)',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: _pickPhoto,
                      icon: const Icon(Icons.photo_camera_outlined),
                      label: const Text('Add photo'),
                    ),
                    const SizedBox(width: 12),
                    if (_photoPreview != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          _photoPreview!,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(labelText: '7. Remarks'),
                  maxLines: 3,
                  onChanged: (value) => _draft.remarks = value,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: (_submitting || blocked) ? null : _submit,
                  child: _submitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('8. SEND'),
                ),
                if (kIsWeb) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'Web browsing is fine. Listing submission is mobile-only.',
                    style: TextStyle(color: AppColors.grey, fontSize: 13),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
