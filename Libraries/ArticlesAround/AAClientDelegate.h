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

@class AAAbstractClient;
@class AAClientRequest;


#pragma mark Delegate protocol for status and results retrieval

@protocol AAClientDelegate

@optional

// Started searching (GeoNames request sent, waiting for reply; MediaWiki's not yet been touched)
- (void)aaClient:(AAAbstractClient *)aaClient
startedSearchingForNearbyArticlesForRequest:(AAClientRequest *)request;

// Finished requesting GeoNames, moving on to MediaWiki's stage to find out which articles don't have pics (or some other metadata)
- (void)aaClient:(AAAbstractClient *)aaClient
startedRefiningNearbyArticlesForRequest:(AAClientRequest *)request;

// Successfully finished searching for nearby articles (GeoNames' and MediaWiki's stages are both done)
- (void)aaClient:(AAAbstractClient *)aaClient
succeededSearchingForNearbyArticlesForRequest:(AAClientRequest *)request
		articles:(NSArray *)articles /* array of AAClientArticle items */;

// Failed searching for nearby articles (at the GeoNames stage, or at the MediaWiki's stage)
- (void)aaClient:(AAAbstractClient *)aaClient
failedSearchingForNearbyArticlesForRequest:(AAClientRequest *)request
		   error:(NSError *)error;

@end
