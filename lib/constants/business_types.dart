/// Business type codes 01–60 from Developer Pack p6.
class BusinessType {
  const BusinessType({required this.code, required this.name});

  final String code;
  final String name;

  String get label => '$code. $name';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessType && code == other.code;

  @override
  int get hashCode => code.hashCode;
}

class BusinessTypes {
  BusinessTypes._();

  static const List<BusinessType> all = [
    BusinessType(code: '01', name: 'Miscellaneous'),
    BusinessType(code: '02', name: 'Accommodation'),
    BusinessType(code: '03', name: 'Accounting Financial and tax affairs'),
    BusinessType(code: '04', name: 'Advertising'),
    BusinessType(code: '05', name: 'Antiques / Collectables'),
    BusinessType(code: '06', name: 'Aquarium'),
    BusinessType(code: '07', name: 'Arts'),
    BusinessType(code: '08', name: 'Awnings / Blinds / Curtains / Shutters'),
    BusinessType(code: '09', name: 'Bakery'),
    BusinessType(code: '10', name: 'Beauty'),
    BusinessType(code: '11', name: 'Bottle shops'),
    BusinessType(code: '12', name: 'Boutiques'),
    BusinessType(code: '13', name: 'Building Materials'),
    BusinessType(code: '14', name: 'Butchery'),
    BusinessType(code: '15', name: 'Café'),
    BusinessType(code: '16', name: 'Chemical manufacturing'),
    BusinessType(code: '17', name: 'Clubs'),
    BusinessType(code: '18', name: 'Computers'),
    BusinessType(code: '19', name: 'Construction and Construction Materials'),
    BusinessType(code: '20', name: 'Crafts'),
    BusinessType(code: '21', name: 'Dental'),
    BusinessType(code: '22', name: 'Education'),
    BusinessType(code: '23', name: 'Farms / Farming'),
    BusinessType(code: '24', name: 'Fashion'),
    BusinessType(code: '25', name: 'Fitness'),
    BusinessType(code: '26', name: 'Florist'),
    BusinessType(code: '27', name: 'Hardware'),
    BusinessType(code: '28', name: 'Healthcare and social assistance'),
    BusinessType(code: '29', name: 'Insurance'),
    BusinessType(code: '30', name: 'Jewellery'),
    BusinessType(code: '31', name: 'Karaoke'),
    BusinessType(code: '32', name: 'Landscape'),
    BusinessType(code: '33', name: 'Laundry'),
    BusinessType(code: '34', name: 'Lawn Mowing'),
    BusinessType(code: '35', name: 'Legal'),
    BusinessType(code: '36', name: 'Lighting'),
    BusinessType(code: '37', name: 'Locksmith'),
    BusinessType(code: '38', name: 'Manufacturing'),
    BusinessType(code: '39', name: 'Marriage / Wedding Services'),
    BusinessType(code: '40', name: 'Mobile phone accessories and Repairs'),
    BusinessType(code: '41', name: 'Newsagents'),
    BusinessType(code: '42', name: 'Optometry / Opticals'),
    BusinessType(code: '43', name: 'Pest Control'),
    BusinessType(code: '44', name: 'Pet'),
    BusinessType(code: '45', name: 'Plant'),
    BusinessType(code: '46', name: 'Plumbing'),
    BusinessType(code: '47', name: 'Postal Services'),
    BusinessType(code: '48', name: 'Real Estate'),
    BusinessType(code: '49', name: 'Restaurants'),
    BusinessType(code: '50', name: 'Retail'),
    BusinessType(code: '51', name: 'Security'),
    BusinessType(code: '52', name: 'Stationery'),
    BusinessType(code: '53', name: 'Supermarkets / Grocery stores'),
    BusinessType(code: '54', name: 'Tattoo'),
    BusinessType(code: '55', name: 'Telecommunication'),
    BusinessType(code: '56', name: 'Tour / Travel'),
    BusinessType(code: '57', name: 'Transportation'),
    BusinessType(code: '58', name: 'Uniforms'),
    BusinessType(code: '59', name: 'Variety Stores'),
    BusinessType(code: '60', name: 'Wholesale trade'),
  ];

  static BusinessType? byCode(String code) {
    final normalized = code.padLeft(2, '0');
    for (final type in all) {
      if (type.code == normalized) return type;
    }
    return null;
  }
}
