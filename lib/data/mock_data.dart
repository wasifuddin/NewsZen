import '../models/news_model.dart'; // Import the NewsModel

List<NewsModel> mockNewsData = [
  NewsModel(
    title: 'Breaking: World Leaders Meet in Geneva for Peace Talks',
    imageurl: 'https://ichef.bbci.co.uk/images/ic/1376xn/p0jxyvnt.jpg.webp',
    source: 'BBC',
    description: 'In an effort to de-escalate tensions, leaders from across the globe gathered in Geneva for unprecedented peace talks aimed at resolving ongoing conflicts. The summit is seen as a last chance for diplomacy. In an effort to de-escalate tensions, leaders from across the globe gathered in Geneva for unprecedented peace talks aimed at resolving ongoing conflicts. The summit is seen as a last chance for diplomacy. In an effort to de-escalate tensions, leaders from across the globe gathered in Geneva for unprecedented peace talks aimed at resolving ongoing conflicts. The summit is seen as a last chance for diplomacy. In an effort to de-escalate tensions, leaders from across the globe gathered in Geneva for unprecedented peace talks aimed at resolving ongoing conflicts. The summit is seen as a last chance for diplomacy. In an effort to de-escalate tensions, leaders from across the globe gathered in Geneva for unprecedented peace talks aimed at resolving ongoing conflicts. The summit is seen as a last chance for diplomacy. In an effort to de-escalate tensions, leaders from across the globe gathered in Geneva for unprecedented peace talks aimed at resolving ongoing conflicts. The summit is seen as a last chance for diplomacy. In an effort to de-escalate tensions, leaders from across the globe gathered in Geneva for unprecedented peace talks aimed at resolving ongoing conflicts. The summit is seen as a last chance for diplomacy. In an effort to de-escalate tensions, leaders from across the globe gathered in Geneva for unprecedented peace talks aimed at resolving ongoing conflicts. The summit is seen as a last chance for diplomacy. In an effort to de-escalate tensions, leaders from across the globe gathered in Geneva for unprecedented peace talks aimed at resolving ongoing conflicts. The summit is seen as a last chance for diplomacy. In an effort to de-escalate tensions, leaders from across the globe gathered in Geneva for unprecedented peace talks aimed at resolving ongoing conflicts. The summit is seen as a last chance for diplomacy.',
    url: 'https://www.bbc.com/news/world-asia-65657996',
    dateTime: DateTime.parse('2024-10-15T10:00:00Z'), // Example date and time
    topic: 'World',
  ),
  NewsModel(
    title: 'Tech Stocks Soar as Markets Recover from Last Week’s Slump',
    imageurl: 'https://ichef.bbci.co.uk/ace/standard/1024/cpsprodpb/7692/live/697a5d10-8bf5-11ef-8936-1185f9e7d044.jpg',
    source: 'CNN',
    description: 'Tech companies led the market recovery today after last week’s downturn. Analysts attribute the rebound to a combination of positive earnings reports and optimism surrounding upcoming product launches.',
    url: 'https://www.cnn.com/2024/10/market-recovery-tech',
    dateTime: DateTime.parse('2024-10-14T12:30:00Z'), // Example date and time
    topic: 'Business',
  ),
  NewsModel(
    title: 'NASA Announces New Mission to Mars: Details Inside',
    imageurl: 'https://ichef.bbci.co.uk/news/1536/cpsprodpb/73e9/live/814c6f30-8bbb-11ef-88cc-639b2e7aa9e9.jpg.webp',
    source: 'Al Jazeera',
    description: 'NASA has officially announced a new mission to Mars, set for launch in 2026. The mission aims to explore the planet’s geology and search for signs of ancient life. This marks NASA’s most ambitious Mars mission to date.',
    url: 'https://www.aljazeera.com/nasa-mission-to-mars-2026',
    dateTime: DateTime.parse('2024-10-13T08:00:00Z'), // Example date and time
    topic: 'Science',
  ),
  NewsModel(
    title: 'Global Climate Action: Countries Commit to Reducing Emissions',
    imageurl: 'https://ichef.bbci.co.uk/news/1536/cpsprodpb/673b/live/aefb6070-8bc6-11ef-b9e0-dbdcd2deee83.jpg.webp',
    source: 'The Guardian',
    description: 'Over 150 countries have signed a new international agreement committing to major reductions in greenhouse gas emissions by 2030. Environmental groups are cautiously optimistic about the agreement’s potential impact.',
    url: 'https://www.theguardian.com/environment/global-climate-action-commitment',
    dateTime: DateTime.parse('2024-10-12T09:15:00Z'), // Example date and time
    topic: 'Environment',
  ),
  NewsModel(
    title: 'AI Revolution: How Artificial Intelligence is Shaping the Future',
    imageurl: 'https://ichef.bbci.co.uk/images/ic/1376xn/p0jxyvnt.jpg.webp',
    source: 'TechCrunch',
    description: 'From healthcare to finance, AI is rapidly transforming industries around the world. This article takes an in-depth look at the latest advancements in AI technology and what the future holds for artificial intelligence.',
    url: 'https://techcrunch.com/ai-revolution-shaping-future',
    dateTime: DateTime.parse('2024-10-11T14:45:00Z'), // Example date and time
    topic: 'Technology',
  ),
  NewsModel(
    title: 'Champions League: Quarterfinals Set After Dramatic Group Stage',
    imageurl: 'https://ichef.bbci.co.uk/images/ic/1376xn/p0jxyvnt.jpg.webp',
    source: 'ESPN',
    description: 'The UEFA Champions League quarterfinal matchups are set after a thrilling group stage. Top clubs from across Europe will now face off in what promises to be an exciting knockout round. Full details inside.',
    url: 'https://www.espn.com/champions-league-quarterfinals-set',
    dateTime: DateTime.parse('2024-10-10T16:00:00Z'), // Example date and time
    topic: 'Sports',
  ),
  NewsModel(
    title: 'COVID-19: Vaccination Rates Surge Amid New Variant Concerns',
    imageurl: 'https://ichef.bbci.co.uk/images/ic/1376xn/p0jxyvnt.jpg.webp',
    source: 'Reuters',
    description: 'Vaccination rates around the world have surged following the discovery of a new COVID-19 variant. Governments are urging citizens to get vaccinated to prevent a new wave of infections, as the variant shows increased transmissibility.',
    url: 'https://www.reuters.com/covid-vaccination-surge-new-variant',
    dateTime: DateTime.parse('2024-10-09T18:20:00Z'), // Example date and time
    topic: 'Health',
  ),
  NewsModel(
    title: 'Electric Vehicles: Revolutionizing the Automotive Industry',
    imageurl: 'https://ichef.bbci.co.uk/images/ic/1376xn/p0jxyvnt.jpg.webp',
    source: 'Bloomberg',
    description: 'Electric vehicles (EVs) are no longer just a trend; they are reshaping the automotive industry. Major automakers are investing billions in EV technology as consumers increasingly demand sustainable alternatives to gas-powered cars.',
    url: 'https://www.bloomberg.com/ev-revolution-automotive-industry',
    dateTime: DateTime.parse('2024-10-08T11:50:00Z'), // Example date and time
    topic: 'Automotive',
  ),
  NewsModel(
    title: 'Artificial Meat: The Future of Sustainable Protein?',
    imageurl: 'https://ichef.bbci.co.uk/images/ic/1376xn/p0jxyvnt.jpg.webp',
    source: 'The Verge',
    description: 'As concerns over the environmental impact of meat production grow, companies are developing lab-grown meat as a sustainable protein source. This article explores the technology behind artificial meat and its potential to disrupt the food industry.',
    url: 'https://www.theverge.com/artificial-meat-future-sustainable-protein',
    dateTime: DateTime.parse('2024-10-07T13:30:00Z'), // Example date and time
    topic: 'Food',
  ),
  NewsModel(
    title: 'SpaceX Successfully Launches Starship to Orbit: What’s Next?',
    imageurl: 'https://ichef.bbci.co.uk/images/ic/1376xn/p0jxyvnt.jpg.webp',
    source: 'Space.com',
    description: 'SpaceX’s Starship spacecraft has successfully completed its first mission to orbit, marking a major milestone in space exploration. The mission paves the way for future manned missions to the Moon and Mars.',
    url: 'https://www.space.com/spacex-starship-successful-orbit-launch',
    dateTime: DateTime.parse('2024-10-06T15:00:00Z'), // Example date and time
    topic: 'Space',
  ),
];
