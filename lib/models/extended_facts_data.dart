import 'extended_facts.dart';

/// Extended facts keyed by ISO country code.
/// Countries not in this map will use basic data only.
const Map<String, ExtendedFacts> allExtendedFacts = {
  'US': ExtendedFacts(
    population: '331 million', areaSqKm: '9,833,520', currency: 'US Dollar (USD)',
    landmark: 'Statue of Liberty', nationalAnimal: 'Bald Eagle', nationalDish: 'Hamburger',
    funFacts: ['The US has 50 states and its flag has 50 stars.', 'Alaska is the largest state — bigger than Texas, California, and Montana combined.', 'The US has no official language at the federal level.', 'Yellowstone was the world\'s first national park (1872).'],
  ),
  'CN': ExtendedFacts(
    population: '1.4 billion', areaSqKm: '9,596,961', currency: 'Chinese Yuan (CNY)',
    landmark: 'Great Wall of China', nationalAnimal: 'Giant Panda', nationalDish: 'Peking Duck',
    funFacts: ['The Great Wall is over 13,000 miles long.', 'China invented paper, printing, gunpowder, and the compass.', 'Table tennis is the national sport.', 'There are more English speakers in China than in the US.'],
  ),
  'IN': ExtendedFacts(
    population: '1.4 billion', areaSqKm: '3,287,263', currency: 'Indian Rupee (INR)',
    landmark: 'Taj Mahal', nationalAnimal: 'Bengal Tiger', nationalDish: 'Biryani',
    funFacts: ['India invented the number zero.', 'India has the most post offices in the world.', 'Chess was invented in India.', 'The Kumbh Mela gathering is visible from space.'],
  ),
  'BR': ExtendedFacts(
    population: '214 million', areaSqKm: '8,515,767', currency: 'Brazilian Real (BRL)',
    landmark: 'Christ the Redeemer', nationalAnimal: 'Jaguar', nationalDish: 'Feijoada',
    funFacts: ['Brazil has the largest rainforest in the world.', 'Brazil has won the FIFA World Cup 5 times — more than any other country.', 'The Amazon River carries more water than any other river.', 'São Paulo is the largest city in the Southern Hemisphere.'],
  ),
  'RU': ExtendedFacts(
    population: '144 million', areaSqKm: '17,098,242', currency: 'Russian Ruble (RUB)',
    landmark: 'Kremlin', nationalAnimal: 'Brown Bear', nationalDish: 'Borscht',
    funFacts: ['Russia is the largest country in the world.', 'Russia spans 11 time zones.', 'Lake Baikal is the deepest lake on Earth.', 'The Trans-Siberian Railway is the longest railway in the world.'],
  ),
  'JP': ExtendedFacts(
    population: '125 million', areaSqKm: '377,975', currency: 'Japanese Yen (JPY)',
    landmark: 'Mount Fuji', nationalAnimal: 'Green Pheasant', nationalDish: 'Sushi',
    funFacts: ['Japan has more than 6,800 islands.', 'Japan has over 50,000 people who are over 100 years old.', 'Vending machines in Japan sell everything from soup to umbrellas.', 'There are more pets than children in Japan.'],
  ),
  'GB': ExtendedFacts(
    population: '67 million', areaSqKm: '242,495', currency: 'British Pound (GBP)',
    landmark: 'Big Ben', nationalAnimal: 'Lion', nationalDish: 'Fish and Chips',
    funFacts: ['The UK has a queen\'s guard that never smiles on duty.', 'London\'s Underground is the oldest metro system in the world.', 'The UK invented football (soccer).', 'Stonehenge is over 5,000 years old.'],
  ),
  'FR': ExtendedFacts(
    population: '67 million', areaSqKm: '640,679', currency: 'Euro (EUR)',
    landmark: 'Eiffel Tower', nationalAnimal: 'Gallic Rooster', nationalDish: 'Crêpes',
    funFacts: ['The Eiffel Tower was supposed to be temporary.', 'France is the most visited country in the world.', 'The Louvre is the largest art museum in the world.', 'France produces over 1,000 types of cheese.'],
  ),
  'DE': ExtendedFacts(
    population: '83 million', areaSqKm: '357,022', currency: 'Euro (EUR)',
    landmark: 'Brandenburg Gate', nationalAnimal: 'Federal Eagle', nationalDish: 'Bratwurst',
    funFacts: ['Germany has over 1,500 types of sausage.', 'Germany has more than 1,500 breweries.', 'The first printed book was made in Germany by Gutenberg.', 'Oktoberfest attracts over 6 million visitors each year.'],
  ),
  'IT': ExtendedFacts(
    population: '60 million', areaSqKm: '301,340', currency: 'Euro (EUR)',
    landmark: 'Colosseum', nationalAnimal: 'Italian Wolf', nationalDish: 'Pizza Margherita',
    funFacts: ['Italy invented pizza and pasta.', 'Italy has the most UNESCO World Heritage Sites.', 'The University of Bologna (1088) is the oldest in the world.', 'Italians eat about 25 kg of pasta per person per year.'],
  ),
  'ES': ExtendedFacts(
    population: '47 million', areaSqKm: '505,992', currency: 'Euro (EUR)',
    landmark: 'Sagrada Familia', nationalAnimal: 'Bull', nationalDish: 'Paella',
    funFacts: ['Spain has a tomato-throwing festival called La Tomatina.', 'Spain has the second most bars per capita in the world.', 'Spanish is spoken in 20+ countries.', 'The oldest restaurant in the world is in Madrid (Sobrino de Botín, 1725).'],
  ),
  'MX': ExtendedFacts(
    population: '128 million', areaSqKm: '1,964,375', currency: 'Mexican Peso (MXN)',
    landmark: 'Chichén Itzá', nationalAnimal: 'Golden Eagle', nationalDish: 'Tacos',
    funFacts: ['Mexico introduced chocolate to the world.', 'Mexico City is sinking at a rate of 10 inches per year.', 'Mexico has 35 UNESCO World Heritage Sites.', 'The Chihuahua dog breed is named after a Mexican state.'],
  ),
  'AU': ExtendedFacts(
    population: '26 million', areaSqKm: '7,692,024', currency: 'Australian Dollar (AUD)',
    landmark: 'Sydney Opera House', nationalAnimal: 'Kangaroo', nationalDish: 'Meat Pie',
    funFacts: ['Australia has animals found nowhere else, like kangaroos and platypuses.', 'The Great Barrier Reef is the largest living structure on Earth.', 'Australia is both a country and a continent.', '80% of Australia\'s animals are unique to Australia.'],
  ),
  'EG': ExtendedFacts(
    population: '104 million', areaSqKm: '1,002,450', currency: 'Egyptian Pound (EGP)',
    landmark: 'Great Pyramids of Giza', nationalAnimal: 'Steppe Eagle', nationalDish: 'Koshari',
    funFacts: ['Egypt has the Great Pyramids, one of the Seven Wonders.', 'Ancient Egyptians invented the 365-day calendar.', 'The Nile is the longest river in Africa.', 'Cleopatra lived closer in time to the Moon landing than to the building of the Great Pyramid.'],
  ),
  'ZA': ExtendedFacts(
    population: '60 million', areaSqKm: '1,221,037', currency: 'South African Rand (ZAR)',
    landmark: 'Table Mountain', nationalAnimal: 'Springbok', nationalDish: 'Bobotie',
    funFacts: ['South Africa has 11 official languages.', 'South Africa has three capital cities.', 'The world\'s first heart transplant was performed in Cape Town.', 'South Africa is called the "Rainbow Nation."'],
  ),
  'KE': ExtendedFacts(
    population: '54 million', areaSqKm: '580,367', currency: 'Kenyan Shilling (KES)',
    landmark: 'Maasai Mara', nationalAnimal: 'Lion', nationalDish: 'Nyama Choma',
    funFacts: ['Kenya is famous for safaris and the Great Migration.', 'Kenyan runners dominate world marathon records.', 'Kenya straddles the equator.', 'The Great Rift Valley runs through Kenya.'],
  ),
  'NG': ExtendedFacts(
    population: '218 million', areaSqKm: '923,768', currency: 'Nigerian Naira (NGN)',
    landmark: 'Zuma Rock', nationalAnimal: 'Eagle', nationalDish: 'Jollof Rice',
    funFacts: ['Nigeria is the most populated country in Africa.', 'Nollywood produces more movies per year than Hollywood.', 'Nigeria has over 500 living languages.', 'Lagos is one of the fastest-growing cities in the world.'],
  ),
  'CA': ExtendedFacts(
    population: '38 million', areaSqKm: '9,984,670', currency: 'Canadian Dollar (CAD)',
    landmark: 'Niagara Falls', nationalAnimal: 'Beaver', nationalDish: 'Poutine',
    funFacts: ['Canada has more lakes than all other countries combined.', 'Canada produces 71% of the world\'s maple syrup.', 'The Trans-Canada Highway is one of the longest in the world.', 'Canada has the longest coastline of any country.'],
  ),
  'AR': ExtendedFacts(
    population: '46 million', areaSqKm: '2,780,400', currency: 'Argentine Peso (ARS)',
    landmark: 'Iguazu Falls', nationalAnimal: 'Rufous Hornero', nationalDish: 'Asado',
    funFacts: ['Argentina is the birthplace of tango dancing.', 'Argentina has the widest avenue in the world (Avenida 9 de Julio).', 'Patagonia has some of the most southern cities on Earth.', 'Argentina has won the FIFA World Cup 3 times.'],
  ),
  'KR': ExtendedFacts(
    population: '52 million', areaSqKm: '100,210', currency: 'South Korean Won (KRW)',
    landmark: 'Gyeongbokgung Palace', nationalAnimal: 'Siberian Tiger', nationalDish: 'Kimchi',
    funFacts: ['South Korea created the Korean alphabet called Hangul.', 'South Korea has the fastest internet in the world.', 'K-pop is a global cultural phenomenon from South Korea.', 'South Korea\'s capital Seoul has a population of 10 million.'],
  ),
  'TR': ExtendedFacts(
    population: '85 million', areaSqKm: '783,562', currency: 'Turkish Lira (TRY)',
    landmark: 'Hagia Sophia', nationalAnimal: 'Grey Wolf', nationalDish: 'Kebab',
    funFacts: ['Turkey sits on two continents: Europe and Asia.', 'Istanbul was once called Constantinople.', 'Turkey introduced tulips to the Netherlands.', 'Turkish baths (hammams) have been used for over 600 years.'],
  ),
  'TH': ExtendedFacts(
    population: '72 million', areaSqKm: '513,120', currency: 'Thai Baht (THB)',
    landmark: 'Grand Palace', nationalAnimal: 'Elephant', nationalDish: 'Pad Thai',
    funFacts: ['Thailand means "Land of the Free."', 'Thailand is the world\'s largest exporter of rice.', 'Thailand has never been colonized by a European country.', 'Bangkok\'s full ceremonial name is 168 characters long.'],
  ),
  'ID': ExtendedFacts(
    population: '275 million', areaSqKm: '1,904,569', currency: 'Indonesian Rupiah (IDR)',
    landmark: 'Borobudur Temple', nationalAnimal: 'Komodo Dragon', nationalDish: 'Nasi Goreng',
    funFacts: ['Indonesia has over 17,000 islands.', 'Indonesia is home to the Komodo dragon — the largest lizard on Earth.', 'Java is the most populated island in the world.', 'Indonesia has over 700 languages.'],
  ),
  'PK': ExtendedFacts(
    population: '230 million', areaSqKm: '881,913', currency: 'Pakistani Rupee (PKR)',
    landmark: 'Badshahi Mosque', nationalAnimal: 'Markhor', nationalDish: 'Biryani',
    funFacts: ['Pakistan has the second-highest mountain in the world, K2.', 'Pakistan has one of the oldest civilizations (Indus Valley, 3300 BCE).', 'Cricket is the most popular sport in Pakistan.', 'The Karakoram Highway is the highest paved international road.'],
  ),
  'PH': ExtendedFacts(
    population: '114 million', areaSqKm: '300,000', currency: 'Philippine Peso (PHP)',
    landmark: 'Chocolate Hills', nationalAnimal: 'Philippine Eagle', nationalDish: 'Adobo',
    funFacts: ['The Philippines has over 7,600 islands.', 'The Philippines is named after King Philip II of Spain.', 'Jeepneys are the most popular form of public transport.', 'The Philippine Eagle is one of the rarest birds in the world.'],
  ),
  'VN': ExtendedFacts(
    population: '99 million', areaSqKm: '331,212', currency: 'Vietnamese Dong (VND)',
    landmark: 'Ha Long Bay', nationalAnimal: 'Water Buffalo', nationalDish: 'Pho',
    funFacts: ['Vietnam is the world\'s largest exporter of cashew nuts.', 'Ha Long Bay has nearly 2,000 limestone islands.', 'Vietnam has the world\'s largest cave — Son Doong.', 'Motorbikes outnumber cars 45 to 1 in Vietnam.'],
  ),
  'GR': ExtendedFacts(
    population: '10 million', areaSqKm: '131,957', currency: 'Euro (EUR)',
    landmark: 'Parthenon', nationalAnimal: 'Dolphin', nationalDish: 'Moussaka',
    funFacts: ['Greece invented the Olympic Games.', 'Greece has more archaeological museums than any other country.', 'About 80% of Greece is mountainous.', 'The Greek alphabet is the oldest still in use today.'],
  ),
  'SE': ExtendedFacts(
    population: '10 million', areaSqKm: '450,295', currency: 'Swedish Krona (SEK)',
    landmark: 'Icehotel', nationalAnimal: 'Eurasian Elk', nationalDish: 'Swedish Meatballs',
    funFacts: ['Sweden invented the zipper and dynamite.', 'Sweden has the right to roam — anyone can walk freely in nature.', 'IKEA was founded in Sweden.', 'Sweden recycles so well it imports trash from other countries.'],
  ),
  'NO': ExtendedFacts(
    population: '5.4 million', areaSqKm: '385,207', currency: 'Norwegian Krone (NOK)',
    landmark: 'Fjords', nationalAnimal: 'Lion (heraldic)', nationalDish: 'Fårikål',
    funFacts: ['Norway has the longest road tunnel in the world.', 'Norway invented the cheese slicer.', 'The Northern Lights are visible in northern Norway.', 'Norway\'s sovereign wealth fund is over \$1 trillion.'],
  ),
  'PL': ExtendedFacts(
    population: '38 million', areaSqKm: '312,696', currency: 'Polish Zloty (PLN)',
    landmark: 'Wieliczka Salt Mine', nationalAnimal: 'White-tailed Eagle', nationalDish: 'Pierogi',
    funFacts: ['Poland has one of the oldest salt mines in the world.', 'Marie Curie was born in Warsaw.', 'Poland has 17 Nobel Prize winners.', 'The Białowieża Forest is home to Europe\'s heaviest land animal — the European bison.'],
  ),
  'NL': ExtendedFacts(
    population: '17 million', areaSqKm: '41,543', currency: 'Euro (EUR)',
    landmark: 'Anne Frank House', nationalAnimal: 'Lion (heraldic)', nationalDish: 'Stroopwafel',
    funFacts: ['The Netherlands has more bicycles than people.', 'About one-third of the Netherlands is below sea level.', 'The Dutch are the tallest people in the world on average.', 'The Netherlands exports more flowers than any other country.'],
  ),
  'CH': ExtendedFacts(
    population: '8.8 million', areaSqKm: '41,285', currency: 'Swiss Franc (CHF)',
    landmark: 'Matterhorn', nationalAnimal: 'St. Bernard Dog', nationalDish: 'Fondue',
    funFacts: ['Switzerland has four official languages.', 'Switzerland has been neutral since 1815.', 'The Swiss eat more chocolate per person than any other country.', 'CERN, where the World Wide Web was invented, is in Switzerland.'],
  ),
  'NZ': ExtendedFacts(
    population: '5.1 million', areaSqKm: '268,021', currency: 'New Zealand Dollar (NZD)',
    landmark: 'Milford Sound', nationalAnimal: 'Kiwi', nationalDish: 'Pavlova',
    funFacts: ['New Zealand has more sheep than people.', 'New Zealand was the first country to give women the right to vote.', 'Lord of the Rings was filmed in New Zealand.', 'New Zealand has no native land snakes.'],
  ),
  'PE': ExtendedFacts(
    population: '33 million', areaSqKm: '1,285,216', currency: 'Peruvian Sol (PEN)',
    landmark: 'Machu Picchu', nationalAnimal: 'Vicuña', nationalDish: 'Ceviche',
    funFacts: ['Peru has Machu Picchu, the ancient Inca city in the clouds.', 'Peru has 90 different microclimates.', 'The Andes run the entire length of Peru.', 'Guinea pig (cuy) is a traditional dish in Peru.'],
  ),
  'CO': ExtendedFacts(
    population: '52 million', areaSqKm: '1,141,748', currency: 'Colombian Peso (COP)',
    landmark: 'Cartagena Old Town', nationalAnimal: 'Andean Condor', nationalDish: 'Bandeja Paisa',
    funFacts: ['Colombia produces the most emeralds in the world.', 'Colombia is the second most biodiverse country on Earth.', 'Colombia is the only South American country with coastlines on both the Pacific and Caribbean.', 'The national bird is the Andean condor, one of the largest flying birds.'],
  ),
  'CL': ExtendedFacts(
    population: '19 million', areaSqKm: '756,102', currency: 'Chilean Peso (CLP)',
    landmark: 'Easter Island', nationalAnimal: 'Andean Huemul', nationalDish: 'Empanadas',
    funFacts: ['Chile is the longest north-to-south country in the world.', 'The Atacama Desert in Chile is the driest place on Earth.', 'Easter Island\'s famous Moai statues are in Chile.', 'Chile produces about a third of the world\'s copper.'],
  ),
  'UA': ExtendedFacts(
    population: '44 million', areaSqKm: '603,550', currency: 'Ukrainian Hryvnia (UAH)',
    landmark: 'Saint Sophia Cathedral', nationalAnimal: 'Common Nightingale', nationalDish: 'Borscht',
    funFacts: ['Ukraine is the largest country entirely in Europe.', 'Kyiv is one of the oldest cities in Eastern Europe.', 'Ukraine was the breadbasket of the Soviet Union.', 'The Chernobyl disaster occurred in Ukraine in 1986.'],
  ),
  'SA': ExtendedFacts(
    population: '36 million', areaSqKm: '2,149,690', currency: 'Saudi Riyal (SAR)',
    landmark: 'Mecca', nationalAnimal: 'Arabian Horse', nationalDish: 'Kabsa',
    funFacts: ['Saudi Arabia has no rivers.', 'Saudi Arabia is the birthplace of Islam.', 'The country has one of the world\'s largest oil reserves.', 'Women gained the right to drive in 2018.'],
  ),
  'IR': ExtendedFacts(
    population: '87 million', areaSqKm: '1,648,195', currency: 'Iranian Rial (IRR)',
    landmark: 'Persepolis', nationalAnimal: 'Asiatic Cheetah', nationalDish: 'Chelo Kebab',
    funFacts: ['Iran was historically known as Persia.', 'Iran has one of the oldest civilizations in the world.', 'Poetry is deeply important in Iranian culture.', 'Iran has 24 UNESCO World Heritage Sites.'],
  ),
  'ET': ExtendedFacts(
    population: '126 million', areaSqKm: '1,104,300', currency: 'Ethiopian Birr (ETB)',
    landmark: 'Rock-hewn Churches of Lalibela', nationalAnimal: 'Lion of Judah', nationalDish: 'Injera with Doro Wot',
    funFacts: ['Ethiopia has its own unique calendar with 13 months.', 'Ethiopia is the birthplace of coffee.', 'Ethiopia was never colonized by a European power.', 'Lucy, one of the oldest human ancestors, was found in Ethiopia.'],
  ),
  'IL': ExtendedFacts(
    population: '9.5 million', areaSqKm: '22,145', currency: 'Israeli Shekel (ILS)',
    landmark: 'Western Wall', nationalAnimal: 'Hoopoe', nationalDish: 'Falafel',
    funFacts: ['The Dead Sea in Israel is the lowest point on Earth.', 'Israel has more startups per capita than any other country.', 'Hebrew was revived as a spoken language in the 20th century.', 'Israel is roughly the size of New Jersey.'],
  ),
  'MA': ExtendedFacts(
    population: '37 million', areaSqKm: '446,550', currency: 'Moroccan Dirham (MAD)',
    landmark: 'Hassan II Mosque', nationalAnimal: 'Barbary Lion', nationalDish: 'Couscous',
    funFacts: ['Morocco has the oldest university in the world (University of al-Qarawiyyin, 859 CE).', 'Morocco is only 8 miles from Spain across the Strait of Gibraltar.', 'The Sahara Desert covers much of southern Morocco.', 'Moroccan mint tea is called "Berber whiskey."'],
  ),
  'IE': ExtendedFacts(
    population: '5 million', areaSqKm: '70,273', currency: 'Euro (EUR)',
    landmark: 'Cliffs of Moher', nationalAnimal: 'Irish Hare', nationalDish: 'Irish Stew',
    funFacts: ['Ireland is known as the "Emerald Isle" for its green landscape.', 'Halloween originated from an ancient Irish festival called Samhain.', 'More people of Irish descent live abroad than in Ireland.', 'The harp is Ireland\'s national symbol — the only country with a musical instrument.'],
  ),
  'DK': ExtendedFacts(
    population: '5.9 million', areaSqKm: '43,094', currency: 'Danish Krone (DKK)',
    landmark: 'The Little Mermaid Statue', nationalAnimal: 'Mute Swan', nationalDish: 'Smørrebrød',
    funFacts: ['LEGO was invented in Denmark.', 'Denmark is consistently ranked as one of the happiest countries.', 'The Danish flag is the oldest national flag still in use.', 'Danes ride bicycles more than almost anyone in the world.'],
  ),
  'FI': ExtendedFacts(
    population: '5.5 million', areaSqKm: '338,424', currency: 'Euro (EUR)',
    landmark: 'Santa Claus Village', nationalAnimal: 'Brown Bear', nationalDish: 'Karjalanpiirakka',
    funFacts: ['Finland is known as the land of saunas and Santa Claus.', 'Finland has about 3 million saunas for 5.5 million people.', 'Finland\'s education system is considered one of the best in the world.', 'Finland has 188,000 lakes.'],
  ),
  'PT': ExtendedFacts(
    population: '10 million', areaSqKm: '92,212', currency: 'Euro (EUR)',
    landmark: 'Tower of Belém', nationalAnimal: 'Iberian Wolf', nationalDish: 'Bacalhau',
    funFacts: ['Portugal is the oldest country in Europe with the same borders.', 'The Portuguese Empire was the first global empire.', 'Portugal decriminalized all drugs in 2001.', 'Pastéis de nata (custard tarts) are Portugal\'s most famous treat.'],
  ),
  'AT': ExtendedFacts(
    population: '9 million', areaSqKm: '83,879', currency: 'Euro (EUR)',
    landmark: 'Schönbrunn Palace', nationalAnimal: 'Golden Eagle', nationalDish: 'Wiener Schnitzel',
    funFacts: ['Mozart was born in Salzburg, Austria.', 'Austria is the birthplace of the waltz.', 'The world\'s oldest zoo is in Vienna (1752).', '"The Sound of Music" was set in Austria.'],
  ),
  'JM': ExtendedFacts(
    population: '3 million', areaSqKm: '10,991', currency: 'Jamaican Dollar (JMD)',
    landmark: 'Dunn\'s River Falls', nationalAnimal: 'Doctor Bird', nationalDish: 'Ackee and Saltfish',
    funFacts: ['Jamaica is the birthplace of reggae music and Bob Marley.', 'Jamaica was the first Caribbean country to gain independence.', 'Usain Bolt, the fastest man ever, is from Jamaica.', 'Jamaica has the most churches per square mile in the world.'],
  ),
};

/// Returns extended facts for a country, or null if not available.
ExtendedFacts? extendedFactsFor(String isoCode) =>
    allExtendedFacts[isoCode.toUpperCase()];
