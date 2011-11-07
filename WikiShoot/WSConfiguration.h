//
// Copyright 2011 Linas Valiukas
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#ifndef _WS_CONFIGURATION_H_
#define _WS_CONFIGURATION_H_

//
// NSUserDefaults initial configuration plist
//
#define WS_USERDEFAULTS_INITIAL_CONFIGURATION_PLIST	@"UserDefaults"	// .plist

//
// NSUserDefaults keys (keep in sync with UserDefaults.plist
//

#define WS_USERDEFAULTS_PLACE_MAP_DEFAULT_LAT_KEY	@"WSPlaceMapDefaultLat"
#define WS_USERDEFAULTS_PLACE_MAP_DEFAULT_LON_KEY	@"WSPlaceMapDefaultLon"
#define WS_USERDEFAULTS_PLACE_MAP_DEFAULT_LATDELTA_KEY	@"WSPlaceMapDefaultLatDelta"
#define WS_USERDEFAULTS_PLACE_MAP_DEFAULT_LONDELTA_KEY	@"WSPlaceMapDefaultLonDelta"
#define WS_USERDEFAULTS_PLACE_MAP_DEFAULT_MAPTYPE_KEY	@"WSPlaceMapDefaultMapType"

//
// MediaWiki API URL
//
#define WS_MEDIAWIKI_URL	@"http://en.wikipedia.org/w/api.php"

//
// GeoNames API username
//
#define WS_GEONAMES_USERNAME	@"wikishoot"

//
// Max. number of articles to find around the coordinate
//
#define WS_ARTICLES_TO_FIND_AROUND_MAX	20

//
// Radius (in kilometers) to search around
//
#define WS_ARTICLES_TO_FIND_AROUND_RADIUS	20

//
// Language code to pass to the GeoNames
//
#define WS_ARTICLES_TO_FIND_AROUND_LANGUAGE_CODE	@"en"

//
// JPEG compression quality
//
#define WS_JPEG_COMPRESSION_QUALITY	90.0


#endif	// '_WS_CONFIGURATION_H_'
