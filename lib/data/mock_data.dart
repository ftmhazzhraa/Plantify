import '../constants/app_assets.dart';
import '../models/models.dart';

class MockData {
  MockData._();

  static final List<PlantProduct> products = [
    PlantProduct(id:'p1', category:'Indoor Plants', name:'Monstera Deliciosa', price:100, hasDiscount:false, rating:4.8, reviewCount:234, image:A.plantProduct,
      description:'The Monstera Deliciosa, also known as the Swiss Cheese Plant, is a stunning tropical houseplant known for its large, glossy, heart-shaped leaves with natural holes. Perfect for bright, indirect light.'),
    PlantProduct(id:'p2', category:'Succulents', name:'Golden Barrel Cactus', price:100, hasDiscount:true, rating:4.6, reviewCount:189, image:A.plantProduct,
      description:'A classic golden barrel cactus with striking symmetrical ribs and bright yellow spines. Extremely low maintenance — perfect for sunny spots and beginners.'),
    PlantProduct(id:'p3', category:'Outdoor Plants', name:'Bird of Paradise', price:100, hasDiscount:false, rating:4.7, reviewCount:156, image:A.plantProduct,
      description:'The Bird of Paradise is a bold tropical plant with large paddle-shaped leaves. Thrives in full sun and adds dramatic flair to any outdoor garden or indoor space.'),
    PlantProduct(id:'p4', category:'Flowering', name:'Peace Lily', price:100, hasDiscount:true, rating:4.9, reviewCount:302, image:A.plantProduct,
      description:'The Peace Lily is one of the most elegant and easy-care flowering houseplants. It purifies the air and blooms beautiful white flowers. Grows well in low light.'),
    PlantProduct(id:'p5', category:'Indoor Plants', name:'Snake Plant', price:100, hasDiscount:false, rating:4.5, reviewCount:98, image:A.plantProduct,
      description:'Snake Plants are nearly indestructible and thrive on neglect. They filter indoor air, tolerate low light, and are ideal for beginners or busy plant parents.'),
    PlantProduct(id:'p6', category:'Tropical', name:'Fiddle Leaf Fig', price:100, hasDiscount:true, rating:4.4, reviewCount:211, image:A.plantProduct,
      description:'The Fiddle Leaf Fig is a trendy indoor tree with large, violin-shaped leaves. It makes a dramatic statement in living rooms and loves bright, indirect sunlight.'),
  ];

  static final List<PlantService> services = [
    PlantService(id:'s1', name:'Plant Consultation', description:'1-on-1 session with our expert botanist to assess your plants and give personalised care advice tailored to your home environment.', price:50, duration:'45 min', image:A.plantProduct, rating:4.9),
    PlantService(id:'s2', name:'Repotting Service', description:'Professional repotting with premium soil mix to give your plants the room they need to grow. Includes new pot recommendations.', price:35, duration:'30 min', image:A.plantProduct, rating:4.7),
    PlantService(id:'s3', name:'Garden Maintenance', description:'Monthly visit to prune, fertilise, and keep your garden looking its best all year round. Suitable for home and office gardens.', price:120, duration:'2 hrs', image:A.plantProduct, rating:4.8),
    PlantService(id:'s4', name:'Same-Day Delivery', description:'Get your plants delivered fresh to your door, same day, within the Klang Valley. Carefully packaged to ensure safe arrival.', price:15, duration:'3–5 hrs', image:A.plantProduct, rating:4.6),
    PlantService(id:'s5', name:'Pest Control', description:'Safe, plant-friendly pest treatment to protect your greens from common infestations including spider mites, mealybugs, and aphids.', price:60, duration:'1 hr', image:A.plantProduct, rating:4.5),
  ];

  static final List<PlantPost> posts = [
    PlantPost(id:'post1', author:'Amirah Hassan', avatar:'AH', title:'My Monstera finally grew a new leaf!', body:'After 3 months of waiting and so much patience, my Monstera Deliciosa finally pushed out a beautiful new fenestrated leaf. Tip: indirect light and weekly watering is the key!', timeAgo:'2h ago', likes:47, comments:2,
      commentList:[
        PostComment(id:'c1', author:'Raj Kumar', avatar:'RK', text:'That is amazing! Mine is taking forever.', timeAgo:'1h ago'),
        PostComment(id:'c2', author:'Nurul Aina', avatar:'NA', text:'The indirect light tip really works!', timeAgo:'30m ago'),
      ]),
    PlantPost(id:'post2', author:'Raj Kumar', avatar:'RK', title:'Best succulents for beginners in Malaysia', body:'If you are just starting out, I recommend Echeveria and Haworthia. They survive our humidity and only need watering every 10-14 days. Great starter plants!', timeAgo:'5h ago', likes:83, comments:1,
      commentList:[
        PostComment(id:'c3', author:'Wei Liang Tan', avatar:'WL', text:'Echeveria is my favourite too!', timeAgo:'4h ago'),
      ]),
    PlantPost(id:'post3', author:'Nurul Aina', avatar:'NA', title:'How I saved my dying peace lily', body:'My peace lily was turning yellow. Turns out I was overwatering it! Switched to once a week and it bounced back in 2 weeks. Do not make the same mistake I did.', timeAgo:'1d ago', likes:124, comments:1,
      commentList:[
        PostComment(id:'c4', author:'Amirah Hassan', avatar:'AH', text:'Same happened to me. Thank you for this!', timeAgo:'20h ago'),
      ]),
    PlantPost(id:'post4', author:'Wei Liang Tan', avatar:'WL', title:'Plantify haul this week', body:'Ordered 3 plants from the Plantify mall — arrived super fresh and well-packaged. The Peace Lily is already blooming. 10/10 would recommend for online plant shopping.', timeAgo:'2d ago', likes:59, comments:0, commentList:[]),
  ];

  static final List<InboxMessage> messages = [
    InboxMessage(id:'m1', sender:'Amirah Hassan', avatarInitials:'AH', subject:'Re: My Monstera post', preview:'Thanks for the kind words! Happy to help.', timeAgo:'10m ago', isRead:false, isNotification:false,
      thread:[ChatMessage(id:'t1', text:'Thanks for the kind words! Happy to help anytime.', isMe:false, time:'10m ago')]),
    InboxMessage(id:'m2', sender:'Dr. Lim (Expert)', avatarInitials:'DL', subject:'Re: Consultation notes', preview:'Here are the care notes from your session.', timeAgo:'1h ago', isRead:false, isNotification:false,
      thread:[ChatMessage(id:'t2', text:'Hi! Here are the care notes from your session yesterday. Let me know if you have any questions.', isMe:false, time:'1h ago')]),
    InboxMessage(id:'m3', sender:'Plantify Deals', avatarInitials:'PD', subject:'Flash sale: 50% off succulents today!', preview:'Don\'t miss out — our biggest sale of the month.', timeAgo:'3h ago', isRead:true, isNotification:true),
    InboxMessage(id:'m4', sender:'Plantify Team', avatarInitials:'PT', subject:'Appointment reminder: Garden Maintenance', preview:'Your appointment is tomorrow at 10:00 AM.', timeAgo:'Yesterday', isRead:true, isNotification:true),
    InboxMessage(id:'m5', sender:'Plantify Rewards', avatarInitials:'PR', subject:'You earned 50 bonus points!', preview:'Your points balance is now 60. Redeem on your next order.', timeAgo:'3d ago', isRead:true, isNotification:true),
  ];

  static final List<DiscoverItem> discoverItems = [
    DiscoverItem(id:'d1', title:'Tropical Paradise Garden', subtitle:'A curated tropical setup perfect for Malaysian homes.', description:'Transform your living space into a lush tropical paradise. This curated collection features bold-leafed plants like Monstera, Bird of Paradise, and Heliconia that thrive in Malaysia\'s climate. Great for brightening up any corner of your home.', category:'Indoor', rating:4.9, image:A.plantProduct),
    DiscoverItem(id:'d2', title:'Succulent Wall Art', subtitle:'Turn your blank wall into a living piece of art.', description:'Vertical gardens are the latest trend in home décor. Use a mix of colourful succulents in geometric frames to create a stunning living wall. Low maintenance and visually striking — perfect for modern Malaysian apartments.', category:'DIY', rating:4.7, image:A.plantProduct),
    DiscoverItem(id:'d3', title:'Herb Garden Starter Kit', subtitle:'Grow your own herbs — mint, basil, lemongrass.', description:'Start your own edible herb garden at home. This starter kit includes everything you need to grow mint, basil, lemongrass, and pandan — herbs commonly used in Malaysian cooking. Fresh flavours right from your windowsill.', category:'Edible', rating:4.8, image:A.plantProduct),
    DiscoverItem(id:'d4', title:'Zen Desk Plants', subtitle:'Best low-maintenance plants for your work desk.', description:'Boost your productivity and reduce stress with a carefully selected set of desk-friendly plants. Snake plants, ZZ plants, and pothos are perfect for offices — they require minimal water and can tolerate fluorescent lighting.', category:'Indoor', rating:4.6, image:A.plantProduct),
    DiscoverItem(id:'d5', title:'Outdoor Flower Beds', subtitle:'Seasonal flowers that thrive in Malaysian weather.', description:'Design a colourful outdoor flower bed suited to Malaysia\'s tropical climate. Bougainvillea, Ixora, and Heliconia are hardy choices that bloom year-round. Perfect for brightening up your garden or condo balcony.', category:'Outdoor', rating:4.5, image:A.plantProduct),
    DiscoverItem(id:'d6', title:'Aquatic Plant Setup', subtitle:'Create a stunning water garden at home.', description:'Aquatic gardens bring a sense of calm and movement to any space. Set up a simple water garden with lotus, water hyacinth, and floating ferns. Suitable for large pots, barrels, or small outdoor ponds.', category:'Aquatic', rating:4.7, image:A.plantProduct),
  ];

  static const List<String> categoryLabels = ['Indoor','Outdoor','Succulent','Flower','Tropical'];
  static const List<String> categoryIcons  = [A.btnIcon1, A.btnIcon2, A.btnIcon3, A.btnIcon4, A.btnIcon5];
}
