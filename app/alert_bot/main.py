import os 
from telegram import Bot
import click
from loguru import logger
import json


DBT_TARGET = os.environ['DBT_TARGET']
API_TOKEN = os.environ['API_TOKEN']
CHAT_ID = os.environ['CHAT_ID']

bot = Bot(token=API_TOKEN)


@click.command()
@click.option('-r', '--run_time_at', type=click.STRING, default=None, help='run_time_at as folder name for dbt log file')
@logger.catch
def main(run_time_at):
    try:
        if not run_time_at:
            logger.info(f"param run_time_at is None")
            exit(0)

        with open(file=f"logs/{DBT_TARGET}/{run_time_at}/dbt.log") as fi:
            full_log = ""
            error_log = ""
            line = fi.readline().rstrip()
            while line:
                dict_row = json.loads(line)
                if 'msg' not in dict_row.keys():
                    continue
                
                full_log += (dict_row['msg'] + '\n')

                if "\"level\": \"error\"" in line:
                    error_log += (dict_row['msg'] + '\n')
                
                line = fi.readline().rstrip()
            
            if not error_log:
                logger.info("error_log is empty")
                exit(0)
            
            error_log = f"[dbt_job_at_{run_time_at}]\n" + error_log
            logger.info(error_log)

            bot.send_message(chat_id=CHAT_ID, text=error_log)
            bot.send_document(chat_id=CHAT_ID, document=str.encode(full_log), filename=f"dbt_job_at_{run_time_at}.txt")
        
    except Exception as exp:
        logger.error(exp)

if __name__=='__main__':
    main()
