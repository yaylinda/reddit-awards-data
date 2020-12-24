import csv
import praw
import time


def write_csv(data):
  filename = 'data.csv'
  column_names = list(data[0].keys())

  print('Writing data to csv, filename=%s' % filename)

  csv_file = open(filename, 'w')
  csv_writer = csv.writer(csv_file, delimiter=',')
  csv_writer.writerow(column_names)
  
  for datum in data:
    csv_writer.writerow([datum[column_names[x]] for x in range(0, len(column_names))])

  csv_file.close()


def get_top_from_subreddit(reddit, subreddit_name):
  
  results = []

  for submission in reddit.subreddit(subreddit_name).top('all'):
    results.append(submission)

  print('Got %d posts from %s' % (len(results), subreddit_name))

  return results


def process_post_awards(data, subreddit_name, posts):

  for post in posts:
    for award in post.all_awardings:
      datum = {}

      datum['subreddit'] = subreddit_name
      datum['award_name'] = award['name']

      data.append(datum)


def main():
  reddit = praw.Reddit('default', user_agent='yaylindadev')

  # From http://redditlist.com/
  top_subreddits = [
    'funny',
    'AskReddit',
    'gaming',
    'aww',
    'pics',
    'science',
    'worldnews',
    'Music',
    'videos',
    'movies',
    'todayilearned',
    'news', 
    'Showerthoughts',
    'IAmA',
    'gifs',
    'EarthPorn',
    'askscience',
    'food',
    'Jokes',
    'explainlikeimfive',
    'books',
    'LifeProTips',
    'blog',
    'Art',
    'mildlyinteresting',
    'DIY',
    'sports',
    'nottheonion',
    'space',
    'gadgets',
    'PublicFreakout',
    'politics',
    'NoStupidQuestions',
    'nextfuckinglevel',
    'tifu',
    'dataisbeautiful',
    'personalfinance',
    'AmItheAsshole',
    'AdviceAnimals',
    'wholesomememes',
    'TwoXChromosomes',
    'photoshopbattles',
    'oddlysatisfying',
    'me_irl',
    'oddlysatisfying',
    'Documentaries',
    'television',
    'UpliftingNews',
    'InternetIsBeautiful',
    'Futurology'
  ]

  data = []

  for subreddit_name in top_subreddits:
    posts = get_top_from_subreddit(reddit, subreddit_name)
    process_post_awards(data, subreddit_name, posts)
    time.sleep(3)

  write_csv(data)

if __name__ == "__main__":
  main()
