class Property {
  final String title;
  final String price;
  final String location;
  final int beds;
  final int baths;
  final String area;
  final String imageUrl;
  final bool isBestOffer;

  Property({
    required this.title,
    required this.price,
    required this.location,
    required this.beds,
    required this.baths,
    required this.area,
    required this.imageUrl,
    this.isBestOffer = false,
  });
}

final List<Property> bestOffers = [
  Property(
    title: "House of Ronak",
    price: 'NRP 8000/month',
    location: '44600 Narayanhiti Palace Museum, Baluwatar, Kathmandu',
    beds: 4,
    baths: 3,
    area: '500sq',
    imageUrl: 'assets/images/onboardingtwoimage.png',
    isBestOffer: true,
  ),
  Property(
    title: "House of Alex",
    price: 'NRP 9000/month',
    location: '44600 Narayanhiti Palace Museum, Baluwatar, Kathmandu',
    beds: 5,
    baths: 3,
    area: '600sq',
    imageUrl: 'assets/images/onboardingtwoimage.png',
    isBestOffer: true,
  ),
  Property(
    title: "House of Ronak",
    price: 'NRP 8000/month',
    location: '44600 Narayanhiti Palace Museum, Baluwatar, Kathmandu',
    beds: 4,
    baths: 3,
    area: '500sq',
    imageUrl: 'assets/images/onboardingtwoimage.png',
    isBestOffer: true,
  ),
];

final List<Property> nearestProperties = [
  Property(
    title: "House of Alex",
    price: 'NRP 9000/month',
    location: '44600 Narayanhiti Palace Museum, Baluwatar, Kathmandu',
    beds: 5,
    baths: 4,
    area: '800sq',
    imageUrl: 'assets/images/onboardingtwoimage.png',
    isBestOffer: true,
  ),
  Property(
    title: "House of Sugar",
    price: 'NRP 10000/month',
    location: '44600 Narayanhiti Palace Museum, Baluwatar, Kathmandu',
    beds: 5,
    baths: 4,
    area: '900sq',
    imageUrl: 'assets/images/onboardingtwoimage.png',
    isBestOffer: true,
  ),
  Property(
    title: "House of Sugar",
    price: 'NRP 10000/month',
    location: '44600 Narayanhiti Palace Museum, Baluwatar, Kathmandu',
    beds: 5,
    baths: 4,
    area: '900sq',
    imageUrl: 'assets/images/onboardingtwoimage.png',
    isBestOffer: true,
  ),
];
