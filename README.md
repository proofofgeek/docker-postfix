### A postfix MTA to relay emails from your Docker containers or host apps to a real SMTP server for delivery - https://github.com/proofofgeek/docker-postfix  
- This works for me (and it might work for you)
  - Tried to make this simple and generic for most standard use cases
  - Your other containers and apps can relay mail through it (see setup below)

1. `git clone https://github.com/proofofgeek/docker-postfix && cd docker-postfix`

2. Edit .env to set your specific config

3. Review (and edit) all other files
  - e.g. if you've created a new network you will need to update:
      - `mynetworks = 127.0.0.0/8 172.17.0.0/16` in Dockerfile
      - uncomment and change `name: shared` in docker-compose.yml  

4. `docker compose up -d`

- Test from within postfix container:  
  `docker exec -it postfix bash`  
  `echo "test" | mail -s "test from postfix" abc@yourdomain.com` (or root)  
  `tail -f /var/log/mail.log`
  
- Configure another container (on the same network):  
  `sudo apt install postfix`  
  Select "4. Satellite System"  
  System mail name: yourdomain.com  
  SMTP relay host: postfix:2525  
  `echo "test" | mail -s "test from another container" abc@yourdomain.com` (or root)

- Notes / To do:
  - automagically configure docker networking
  - switch to alpine base?  
  - better way to build without .env?