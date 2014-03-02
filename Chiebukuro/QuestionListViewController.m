//
//  QuestionListViewController.m
//  Chiebukuro
//
//  Created by koogawa on 2013/12/01.
//  Copyright (c) 2013年 Kosuke Ogawa, Shingo Sato. All rights reserved.
//

#import "QuestionListViewController.h"
#import "WebViewController.h"

@interface QuestionListViewController ()
@property (strong, nonatomic) NSArray *questions; // 新着質問リスト
@end

@implementation QuestionListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self fetchNewQuestions];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private method

- (void)fetchNewQuestions
{
    NSURLSession *session = [NSURLSession sharedSession];

    NSURL *url = [NSURL URLWithString:@"http://chiebukuro.yahooapis.jp/Chiebukuro/V1/getNewQuestionList?appid=(YOUR_APPID)&condition=open&results=20&output=json"];

    NSURLSessionDataTask *task =
    [session dataTaskWithURL:url
           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
     {
         if (error)
         {
             // 通信が異常終了したときの処理
             return;
         }

         // 通信が正に常終了したときの処理
         NSError *jsonError = nil;
         NSDictionary *jsonDictionary =
         [NSJSONSerialization JSONObjectWithData:data
                                         options:0
                                           error:&jsonError];

         // JSONエラーチェック
         if (jsonError != nil) return;

         // 検索結果をディクショナリにセット
         self.questions = jsonDictionary[@"ResultSet"][@"Result"];

         // TableView をリロード
         // メインスレッドでやらないと最悪クラッシュする
         [self performSelectorOnMainThread:@selector(reloadTableView)
                                withObject:nil
                             waitUntilDone:YES];
     }];

    // 通信開始
    [task resume];
}

// テーブルビューを再描画する
- (void)reloadTableView
{
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.questions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    NSDictionary *question = self.questions[indexPath.row];

    cell.textLabel.text = question[@"Content"];
    cell.detailTextLabel.text = question[@"Category"];
    
    return cell;
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewCell *cell = (UITableViewCell *)sender;

    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *question = self.questions[indexPath.row];

    WebViewController *viewController = [segue destinationViewController];
    viewController.url = [NSURL URLWithString:question[@"QuestionUrl"]];
}

@end
