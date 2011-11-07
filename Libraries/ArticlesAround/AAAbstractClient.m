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

#import "AAAbstractClient.h"
#import "MWDefines.h"


NSString *const kAAClientErrorDomain = @"lt.pypt.aaclient";


#pragma mark - AAClient private methods

@interface AAAbstractClient (Private)

@end

@implementation AAAbstractClient (Private)


@end


#pragma mark - AAClient public methods


@implementation AAAbstractClient

@synthesize delegate;


- (id)init {
	
	if ((self = [super init])) {
		delegate = nil;
	}
	
	return self;
}

- (id)initWithDelegate:(id<AAClientDelegate>)initDelegate {
	
	if ((self = [self init])) {
		delegate = initDelegate;
	}
	
	return self;
}

- (void)searchForNearbyArticlesForRequest:(AAClientRequest *)request {
	// Do not use directly
	MW_DUMMY_IMPL_EXC();
}

@end
