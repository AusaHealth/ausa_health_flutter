'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "10c3ec53b41ef157e0395d878c063cc6",
"version.json": "b5a0058016262694784e791cd9b033ee",
"index.html": "1e654c18afff975da0f61c2f25606148",
"/": "1e654c18afff975da0f61c2f25606148",
"main.dart.js": "099336388617df051108415b6ea6b69e",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "5ead20f380826cfad3709b7df57f2367",
"assets/AssetManifest.json": "c1031efb5a758a682dae49c9a7cd6b50",
"assets/NOTICES": "0a5591cff5c33e8daeef2c65847e87f6",
"assets/FontManifest.json": "8fac3349b566e73005b1fcc307cde714",
"assets/AssetManifest.bin.json": "4237fa5dfd3b7a227b00bb4be6787cbc",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e626e54b1ae11c6ad362bb63f8db2f85",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "7e5096a134a5700ac764ad279c6377a0",
"assets/fonts/MaterialIcons-Regular.otf": "5eea8c1f000f792454816baa8ef8f8c2",
"assets/assets/images/gradient.png": "3872647b548d18c53b4400386499a042",
"assets/assets/images/X.png": "1aa445ecd0bb73366f1a3fd2b762a4e6",
"assets/assets/images/ecg.png": "77e5f01052c2e6bb1b51fd738ccb08f2",
"assets/assets/images/ausa_connect.png": "5da3a403c91bd584957b3efbe8b69f89",
"assets/assets/images/test_image.png": "12822867b446e6e226e4664977b2411c",
"assets/assets/images/blood.png": "707c480c78fa92827c0a88ae42e05e57",
"assets/assets/images/ausa_health_logo.png": "f90a4681c9494c897fa91d7b6a81e082",
"assets/assets/images/test_ins.png": "825aff2e09a7994a2d68263ae4454714",
"assets/assets/images/profile.png": "b5d6c365752b114f0b6c0f6caa3dd0df",
"assets/assets/icons/setting_icon/bluetooth_selected.png": "2c2bd1636f001ddb1be0f44d8ea83959",
"assets/assets/icons/setting_icon/wifi.png": "76694a9286420dd77348e1f17c808f1b",
"assets/assets/icons/setting_icon/bluetooth.png": "9c5560607e7c877b71df8b8ac5347fe9",
"assets/assets/icons/setting_icon/display_selected.png": "b871cc9fa1bc73b3a0f7fd3e1bc78cef",
"assets/assets/icons/setting_icon/notification_selected.png": "f35e4ace13f03acbbd602135cacded21",
"assets/assets/icons/setting_icon/call_setting_selected.png": "48d394a238b7b09d2e98cd479318caa8",
"assets/assets/icons/setting_icon/display.png": "f06cd05f6d529d8848329625380a93ac",
"assets/assets/icons/setting_icon/wifi_selected.png": "4284783c01577c4d3f38caf668e053a4",
"assets/assets/icons/setting_icon/notification.png": "37cd3bf43ee00a80e6aaf100776ac330",
"assets/assets/icons/setting_icon/not_found.png": "fe93f1a57f9711ab4bb50727fa0c694e",
"assets/assets/icons/setting_icon/call_setting.png": "fa27b9875991f4aee551916e5b4566f2",
"assets/assets/icons/setting_icon/connecting.png": "6daa81f63cfdca7ff301fe9528c1b82f",
"assets/assets/icons/Icon.png": "22343a2825815015dc0c2ef3fd66dc4e",
"assets/assets/icons/person.svg": "de0b0332fb002b06351d612209804bb0",
"assets/assets/icons/doctor.svg": "c1715de8f9de329fad8554efe7bc891f",
"assets/assets/icons/mike.svg": "778911d0aa82a624066c9f9af6687d2f",
"assets/assets/icons/phone.svg": "d179831132fd18f9b628411dfcd0f013",
"assets/assets/icons/profile_icons/condition_selected.png": "84fac988accb3694bc982a738aa411a5",
"assets/assets/icons/profile_icons/family_unselected.png": "e5029c900d2198a29ca19cf6db9d2426",
"assets/assets/icons/profile_icons/care_selected.png": "e177a199fa259d53aa54568e13aaba52",
"assets/assets/icons/profile_icons/family_selected.png": "9a9d579814bdd5276b4ad2a815b46329",
"assets/assets/icons/profile_icons/condition_unselected.png": "c066d2a7e1f2965eaf6786a215693e4a",
"assets/assets/icons/profile_icons/profile_unselected.png": "9ccc617fb0f6fb9d01f103b96226780f",
"assets/assets/icons/profile_icons/ausa_content_selected.png": "a14d095582ef5051b028587a2c0d37a2",
"assets/assets/icons/profile_icons/ausa_content_unselected.png": "e3157136d80071754023f2259a593f07",
"assets/assets/icons/profile_icons/profile_selected.png": "535d3027298a1b1115d7f82d0792180e",
"assets/assets/icons/profile_icons/ausa_logo.png": "339c8e936dd7f89634c1726ea6fa5e9b",
"assets/assets/icons/profile_icons/care_unselected.png": "97950b993b965b383a31d81dc1132e83",
"assets/assets/icons/video.svg": "240a4409672a5ccabf4ca2f078bb26ef",
"assets/assets/icons/onboarding/us_flag.png": "4d5200c279ad7c04053ae63e80c928bf",
"assets/assets/icons/onboarding/phone_unselected.png": "9ae264855cf9d0811a639e590ed052f8",
"assets/assets/icons/onboarding/phone_selected.png": "9d3e3b1c3421b93c5793aaf8326290d7",
"assets/assets/icons/onboarding/terms_selected.png": "1a6b2334b033d42d971ca2c1b0365a29",
"assets/assets/icons/onboarding/china_flag.png": "003d314b69c798ba49c0b3c4392c727c",
"assets/assets/icons/onboarding/done.png": "57ae9b03709f601551f6a0e1e7b205ba",
"assets/assets/icons/onboarding/lang_selected.png": "b7f8af38eb1e38bf999acac392e2c85f",
"assets/assets/icons/onboarding/wifi_unselected.png": "22343a2825815015dc0c2ef3fd66dc4e",
"assets/assets/icons/onboarding/wifi_selected.png": "72c9f5c8de1b59bcb5ee33dac50708b4",
"assets/assets/icons/onboarding/terms_unselected.png": "df0511a992a4891f1977d80e63597815",
"assets/assets/icons/onboarding/espanol_flag.png": "4c7e14b0c26065dd5dbbe48ccb7d4c19",
"assets/assets/icons/test.svg": "0018a95a038e3c3b98f094b806897544",
"assets/assets/fonts/Inter-Medium.ttf": "4591e900425d177e6ba268d165bf12e8",
"assets/assets/fonts/Inter-Light.ttf": "65ec965bd90e1a297cdb3be407420abc",
"assets/assets/fonts/Inter-Thin.ttf": "1e9e30c74648950a240427636b6c1992",
"assets/assets/fonts/Inter-Bold.ttf": "8b04b3bd9435341377d7f4b4d68b6ecc",
"assets/assets/fonts/Inter-Regular.ttf": "e48c1217adab2a0e44f8df400d33c325",
"assets/assets/fonts/Inter-ExtraBold.ttf": "995fb5ac38b90303c0cc1a0b21e2c9fe",
"assets/assets/fonts/Inter-ExtraLight.ttf": "8da347e947a38e1262841f21fe7c893e",
"assets/assets/fonts/Inter-Black.ttf": "2392341284c30f5fffb9fe0ab0cd983e",
"assets/assets/fonts/Inter-SemiBold.ttf": "c77560a8441d664af3e65dd57026dff9",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
