#!/usr/bin/env python3

import os
import sys
import json
from telegram import Bot
from loguru import logger
from datetime import datetime


DBT_TARGET = os.environ['DBT_TARGET']
API_TOKEN = os.environ['API_TOKEN']
CHAT_ID = os.environ['CHAT_ID']

bot = Bot(token=API_TOKEN)


@logger.catch
def main():
        full_log = ""
        error_log = ""

        # Read output line by line
        for line in sys.stdin.readlines():
            dict_row = json.loads(line)
            if 'msg' not in dict_row.keys():
                continue
            
            logger.info(f"{dict_row['msg']}")
            full_log += (dict_row['msg'] + '\n')

            if "\"level\": \"error\"" in line:
                error_log += (dict_row['msg'] + '\n')
        
        if not error_log:
            exit(0)
        
        log_title = f"dbt_job_{datetime.now().strftime('%Y-%m-%d_%H:%M_%S.%f')}"
        error_log = f"[{log_title}]\n" + error_log

        bot.send_message(chat_id=CHAT_ID, text=error_log)
        bot.send_document(chat_id=CHAT_ID, document=str.encode(full_log), filename=f"{log_title}.log")

if __name__=='__main__':
    main()
