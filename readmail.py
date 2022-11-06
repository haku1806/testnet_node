import imaplib
import base64
import re
import email
import socks
from typing import Container
from bs4 import BeautifulSoup
import xml.sax.saxutils as saxutils

def read_mail_test(SERVER, EMAIL, PASSWORD, MailTo):
    try:
        print(SERVER)
        print(EMAIL)
        print(PASSWORD)
        print(MailTo)
        M = imaplib.IMAP4_SSL(SERVER, 993)
        M.login(EMAIL, PASSWORD)
        M.select()
            
        # fromMail = '(FROM "no-reply@mail.instagram.com")'
        findKey = '(TO "' + MailTo + '")'
        typ, message_numbers = M.search(None, f'SUBJECT "Huge Flash Sale: Save on popular domains"', findKey)  # change variable name, and use new name in for loop
        print(len(message_numbers[0].split()))
        for num in reversed(message_numbers[0].split()):
            typ, data = M.fetch(num, '(RFC822)')
            email_message = {
                part.get_content_type(): part.get_payload()
                for part in email.message_from_bytes(data[0][1]).walk()
            }

            # page = email_message["text/html"]
            print(email_message)
            # code = re.findall('\d{6}', page)
            # return code[0]

        M.close()
        M.logout()
    except Exception as ex:
        print(ex)
        return "Loi"


print(read_mail_test("imap.gmail.com", "thangtranit2000@gmail.com", "dorbtbhretkmxwxu", "thangtranit2000@gmail.com"))