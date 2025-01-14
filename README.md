*) This works for me (and it might work for you)
   - Tried to make this super simple and generic for basic use cases
   - Host, containers and apps can relay mail through it (see setup below)
   - Probably won't work with company and/or non-standard email setups

1) git clone https://github.com/proofofgeek/docker-postfix && cd docker-postfix

2) Edit .env to set your config

3) Review (and edit) all other files, e.g. network settings

4) docker compose up -d

*) Test from within postfix container
   <code>docker exec -it postfix bash</code>
   <code>echo "test" | mail -s "testing from postfix" something@yourdomain.com</code> (or root)
   <code>tail -f /var/log/mail.log</code>
  
*) Configure another container (connected to the same network)
   <code>sudo apt install postfix</code>
   Select "4. Satellite System"
   System mail name: yourdomain.com
   SMTP relay host: postfix:2525
   <code>echo "test" | mail -s "testing from another container" something@yourdomain.com</code> (or root)

*) Enjoy

NOTES / TO DO:
> maybe switch to alpine base
> troubleshooting guide
> better way to build without .env
