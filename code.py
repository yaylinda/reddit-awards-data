import csv
import praw

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

  # Top from https://blog.oneupapp.io/biggest-subreddits/
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
    'news'
  ]

  data = []

  for subreddit_name in top_subreddits:
    posts = get_top_from_subreddit(reddit, subreddit_name)
    process_post_awards(data, subreddit_name, posts)

  write_csv(data)

if __name__ == "__main__":
  main()
