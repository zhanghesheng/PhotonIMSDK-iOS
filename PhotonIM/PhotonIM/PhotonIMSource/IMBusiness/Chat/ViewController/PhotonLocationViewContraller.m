//
//  PhotonLocationViewContraller.m
//  PhotonIM
//
//  Created by Bruce on 2020/1/10.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import "PhotonLocationViewContraller.h"

@interface PhotonLocationViewContraller ()<MKMapViewDelegate, CLLocationManagerDelegate,UIGestureRecognizerDelegate>
@property (nonatomic) BOOL canSend;

@property (nonatomic) CLLocationCoordinate2D locationCoordinate;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *detailAddress;

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) MKPointAnnotation *annotation;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign)BOOL initLocation;
@end

@implementation PhotonLocationViewContraller
- (instancetype)init
{
    self = [super init];
    if (self) {
        _canSend = YES;
        _initLocation = NO;
    }
    
    return self;
}
- (instancetype)initWithLocation:(CLLocationCoordinate2D)locationCoordinate{
    self = [super init];
       if (self) {
           _canSend = NO;
           _locationCoordinate = locationCoordinate;
       }
       
       return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地理位置";
    self.view.backgroundColor = [UIColor whiteColor];
    [self _setupSubviews];
    if (self.canSend) {
        self.mapView.showsUserLocation = YES;//显示当前位置
        [self _startLocation];
    } else {
        [self _moveToLocation:self.locationCoordinate];
    }
}

- (void)_setupSubviews
{
    

    if (self.canSend) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendAction)];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"location"] style:UIBarButtonItemStylePlain target:self action:@selector(shared)];
    }
    
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, NavAndStatusHight, PhotoScreenWidth, PhotoScreenHeight -NavAndStatusHight)];
    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.userTrackingMode=MKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
    self.mapView.zoomEnabled = YES;
    [self.view addSubview:self.mapView];
    
    if (self.canSend) {
        UILongPressGestureRecognizer *lpGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(lpgrClick:)];
        [lpGesture setDelegate:self];
        [self.mapView addGestureRecognizer:lpGesture];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panClick:)];
        [panGesture setDelegate:self];
        [self.mapView addGestureRecognizer:panGesture];
    }
    
    self.annotation = [[MKPointAnnotation alloc] init];
}

#pragma mark - Private

- (void)_startLocation
{
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 5;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;//kCLLocationAccuracyBest;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    
    [PhotonUtil showLoading:@"正在定位..."];
}

- (void)_moveToLocation:(CLLocationCoordinate2D)locationCoordinate
{
    [PhotonUtil hiddenLoading];
    
    self.locationCoordinate = locationCoordinate;
    float zoomLevel = 0.01;
    MKCoordinateRegion region = MKCoordinateRegionMake(self.locationCoordinate, MKCoordinateSpanMake(zoomLevel, zoomLevel));
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    [self.mapView removeAnnotation:self.annotation];
    self.annotation.coordinate = locationCoordinate;
    [self.mapView addAnnotation:self.annotation];

    
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (self.initLocation) {
        return;
    }
    __weak typeof(self) weakself = self;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *array, NSError *error) {
        if (!error && array.count > 0) {
            CLPlacemark *placemark = [array firstObject];
            //设置标题
            userLocation.title=placemark.locality;
            //设置子标题
            userLocation.subtitle=placemark.name;
            
            weakself.address = placemark.name;
            weakself.detailAddress = [placemark.addressDictionary[@"FormattedAddressLines"] firstObject];
            
            [weakself _moveToLocation:userLocation.coordinate];
            
        }
    }];
    self.initLocation = YES;
}
- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
     [PhotonUtil hiddenLoading];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];
            }
            break;
        case kCLAuthorizationStatusDenied:
            break;
        default:
            break;
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
}

- (void)lpgrClick:(UILongPressGestureRecognizer *)lpgr
{
    __weak typeof(self)weakSelf = self;
    if(lpgr.state == UIGestureRecognizerStateBegan)
    {
        [_mapView removeAnnotations:_mapView.annotations];
        CGPoint point = [lpgr locationInView:_mapView];
        CLLocationCoordinate2D center = [_mapView convertPoint:point toCoordinateFromView:_mapView];
        self.locationCoordinate = center;
        MKPointAnnotation *pinAnnotation = [[MKPointAnnotation alloc] init];
        pinAnnotation.coordinate = center;
        pinAnnotation.title = @"长按";
        CLGeocoder *geocoder=[[CLGeocoder alloc]init];
        [geocoder reverseGeocodeLocation:[[CLLocation alloc]initWithLatitude:center.latitude longitude:center.longitude] completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (error!=nil || placemarks.count==0) {
                return ;
            }
            CLPlacemark *placemark=[placemarks firstObject];
            pinAnnotation.title=placemark.locality;
            pinAnnotation.subtitle=placemark.name;
            weakSelf.address = placemark.name;
            weakSelf.detailAddress = [placemark.addressDictionary[@"FormattedAddressLines"] firstObject];
            [weakSelf.mapView addAnnotation:pinAnnotation];
        }];
        
    }
}

- (void)panClick:(UIPanGestureRecognizer *)panG
{
    __weak typeof(self)weakSelf = self;
    if(panG.state == UIGestureRecognizerStateEnded)
    {
        [_mapView removeAnnotations:_mapView.annotations];
        CGPoint point = _mapView.center;
        CLLocationCoordinate2D center = [_mapView convertPoint:point toCoordinateFromView:_mapView];
        self.locationCoordinate = center;
        MKPointAnnotation *pinAnnotation = [[MKPointAnnotation alloc] init];
        pinAnnotation.coordinate = center;
        pinAnnotation.title = @"长按";
        CLGeocoder *geocoder=[[CLGeocoder alloc]init];
        [geocoder reverseGeocodeLocation:[[CLLocation alloc]initWithLatitude:center.latitude longitude:center.longitude] completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (error!=nil || placemarks.count==0) {
                return ;
            }
            CLPlacemark *placemark=[placemarks firstObject];
            pinAnnotation.title=placemark.locality;
            pinAnnotation.subtitle=placemark.name;
            weakSelf.address = placemark.name;
            weakSelf.detailAddress = [placemark.addressDictionary[@"FormattedAddressLines"] firstObject];
            [weakSelf.mapView addAnnotation:pinAnnotation];
        }];
        
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - Action

- (void)closeAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendAction
{
    if (self.sendCompletion) {
           self.sendCompletion(self.locationCoordinate, self.address,self.detailAddress);
    }
    [self.navigationController popViewControllerAnimated:YES];
   
}

- (void)shared{
    
}

@end
