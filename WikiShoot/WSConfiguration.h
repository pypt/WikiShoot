//
//  WSConfiguration.h
//  WikiShoot
//
//  Created by Linas Valiukas on 2011-11-06.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
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
