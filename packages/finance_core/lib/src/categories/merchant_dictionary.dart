import 'seed_categories.dart';

/// A group of merchant names and words that mean one category.
final class MerchantPattern {
  const MerchantPattern(this.categoryId, this.why, this.keywords);

  final String categoryId;

  /// Finishes "… looks like …" in "see why", e.g. `a food delivery app`.
  final String why;

  /// Lower case, matched as whole words in the payee, UPI ID and narration.
  final List<String> keywords;
}

/// The built-in dictionary, checked in order: specific merchants before
/// broad words, and payment platforms (which wrap other merchants) last.
/// Names are public brand names, used only to recognise payees.
const merchantPatterns = <MerchantPattern>[
  // Quick commerce and groceries come before their food-delivery parents.
  MerchantPattern(Cat.groceries, 'a grocery delivery app', [
    'instamart', 'blinkit', 'grofers', 'zepto', 'bigbasket', 'bbnow', //
    'jiomart', 'dunzo', 'swiggy instamart', 'flipkart minutes',
  ]),
  MerchantPattern(Cat.foodDelivery, 'a food delivery app', [
    'swiggy', 'zomato', 'eatsure', 'faasos', 'box8', 'freshmenu', //
    'magicpin',
  ]),
  MerchantPattern(Cat.eatingOut, 'a restaurant or cafe', [
    'mcdonalds', 'mcdonald', 'kfc', 'dominos', 'domino', 'pizza hut', //
    'burger king', 'subway', 'starbucks', 'chaayos', 'chai point',
    'cafe coffee day', 'ccd', 'haldiram', 'haldirams', 'barbeque nation',
    'wow momo', 'third wave coffee', 'blue tokai', 'restaurant', 'cafe',
    'bakery', 'bakers', 'sweets', 'dhaba', 'canteen', 'hotel', 'biryani',
    'tea stall', 'juice', 'kitchen', 'eatery', 'udupi', 'bhavan', 'mess',
  ]),
  MerchantPattern(Cat.groceries, 'a grocery shop', [
    'dmart', 'd mart', 'avenue supermarts', 'reliance fresh', //
    'more retail', 'more supermarket', 'spencers', 'ratnadeep',
    'nature s basket', 'star bazaar', 'kirana', 'supermarket', 'grocery',
    'groceries', 'provision', 'provisions', 'general store', 'dairy',
    'milk', 'vegetables', 'fruits', 'country delight', 'milkbasket',
  ]),
  MerchantPattern(Cat.fuel, 'a fuel station', [
    'indian oil', 'iocl', 'bharat petroleum', 'bpcl', 'hpcl', //
    'hindustan petroleum', 'shell', 'nayara', 'petrol', 'petroleum',
    'fuel', 'filling station', 'fuels', 'service station',
  ]),
  MerchantPattern(Cat.travel, 'travel or a ride', [
    'uber', 'ola', 'olacabs', 'rapido', 'namma yatri', 'bluesmart', //
    'irctc', 'indian railways', 'redbus', 'makemytrip', 'goibibo',
    'cleartrip', 'ixigo', 'easemytrip', 'yatra', 'indigo', 'interglobe',
    'air india', 'akasa', 'spicejet', 'vistara', 'metro', 'bmrcl',
    'dmrc', 'fastag', 'netc', 'parking', 'toll', 'oyo', 'airbnb',
    'booking com', 'agoda', 'zoomcar', 'yulu',
  ]),
  MerchantPattern(Cat.subscriptions, 'a subscription', [
    'netflix', 'spotify', 'youtube premium', 'youtube', 'hotstar', //
    'disney', 'jiohotstar', 'jiocinema', 'sonyliv', 'zee5', 'prime video',
    'amazon prime', 'apple com bill', 'apple services', 'google play',
    'icloud', 'chatgpt', 'openai', 'claude ai', 'anthropic', 'notion',
    'canva', 'microsoft', 'adobe', 'linkedin', 'audible', 'kindle',
  ]),
  MerchantPattern(Cat.entertainment, 'entertainment', [
    'bookmyshow', 'pvr', 'inox', 'cinepolis', 'paytm insider', //
    'steam', 'playstation', 'xbox', 'dream11', 'mpl', 'cinema', 'movies',
    'gaming', 'concert',
  ]),
  MerchantPattern(Cat.phoneInternet, 'a phone or internet bill', [
    'jio', 'reliance jio', 'airtel', 'bharti airtel', 'vodafone', //
    'vodafone idea', 'bsnl', 'act fibernet', 'hathway', 'tata play',
    'dish tv', 'd2h', 'broadband', 'recharge', 'prepaid', 'postpaid',
  ]),
  MerchantPattern(Cat.bills, 'a utility bill', [
    'bescom', 'tneb', 'tangedco', 'msedcl', 'mahavitaran', 'bses', //
    'tata power', 'adani electricity', 'torrent power', 'cesc', 'kseb',
    'electricity', 'water', 'bwssb', 'gas', 'indane', 'hp gas',
    'bharat gas', 'mahanagar gas', 'igl', 'piped gas', 'bbps',
    'billdesk', 'maintenance', 'society', 'mygate', 'nobrokerhood',
  ]),
  MerchantPattern(Cat.rent, 'rent', [
    'rent',
    'house rent',
    'nobroker rent',
    'cred rent',
  ]),
  MerchantPattern(Cat.loans, 'a loan repayment', [
    'emi', 'loan', 'bajaj finance', 'bajaj finserv', 'home credit', //
    'hdb financial', 'tata capital', 'kreditbee', 'moneyview', 'navi',
    'lazypay', 'simpl', 'zestmoney', 'ach d', 'nach', 'ecs',
  ]),
  MerchantPattern(Cat.insurance, 'insurance', [
    'insurance', 'lic', 'life insurance', 'policybazaar', 'acko', //
    'digit insurance', 'hdfc life', 'icici prudential', 'icici lombard',
    'sbi life', 'max life', 'star health', 'niva bupa', 'care health',
    'premium',
  ]),
  MerchantPattern(Cat.health, 'health or medicine', [
    'apollo', 'pharmeasy', 'netmeds', '1mg', 'tata 1mg', 'medplus', //
    'practo', 'cult fit', 'cultfit', 'pharmacy', 'medical', 'medicals',
    'chemist', 'hospital', 'clinic', 'diagnostics', 'dental',
    'healthcare',
  ]),
  MerchantPattern(Cat.education, 'education', [
    'byjus', 'unacademy', 'udemy', 'coursera', 'upgrad', 'vedantu', //
    'school', 'college', 'university', 'tuition', 'academy', 'fees',
    'institute', 'books',
  ]),
  MerchantPattern(Cat.personalCare, 'personal care', [
    'urban company', 'urbanclap', 'nykaa', 'salon', 'parlour', //
    'parlor', 'barber', 'spa', 'lakme', 'gym', 'fitness',
  ]),
  MerchantPattern(Cat.giftsDonations, 'a gift or donation', [
    'donation', 'temple', 'trust', 'charity', 'giveindia', 'ketto', //
    'milaap', 'ferns n petals', 'fnp', 'igp',
  ]),
  MerchantPattern(Cat.investments, 'an investment', [
    'zerodha', 'groww', 'upstox', 'angel one', 'kuvera', //
    'mutual fund', 'sip', 'nps', 'ppf', 'indian clearing corp',
    'iccl', 'nse clearing', 'bse', 'cams', 'kfintech', 'smallcase',
    'fixed deposit', 'recurring deposit', 'rd installment', 'sgb',
  ]),
  MerchantPattern(Cat.shopping, 'shopping', [
    'amazon', 'flipkart', 'myntra', 'ajio', 'meesho', 'snapdeal', //
    'tata cliq', 'croma', 'reliance digital', 'vijay sales', 'decathlon',
    'ikea', 'pepperfry', 'lenskart', 'firstcry', 'westside', 'zudio',
    'trends', 'max fashion', 'pantaloons', 'lifestyle', 'shoppers stop',
    'h m', 'uniqlo', 'mall', 'store', 'stores', 'mart', 'enterprises',
    'traders', 'electronics', 'mobiles', 'textiles', 'fashion',
    'footwear', 'stationery',
  ]),
];
