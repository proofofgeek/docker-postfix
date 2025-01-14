- This works for me (and it might work for you)
  - Tried to make this super simple and generic for basic use cases
  - Host, containers and apps can relay mail through it (see setup below)
  - Probably won't work with company and/or non-standard email setups

1. `git clone https://github.com/proofofgeek/docker-postfix && cd docker-postfix`

2. edit .env to set your specific config

3. review (and edit if needed) all other files, e.g. network settings

4. `docker compose up -d`

- Test from within postfix container:  
  `docker exec -it postfix bash`  
  `echo "test" | mail -s "test from postfix" abc@yourdomain.com` (or root)  
  `tail -f /var/log/mail.log`
  
- Configure another container (connected to the same docker network):  
  `sudo apt install postfix`  
  Select "4. Satellite System"  
  System mail name: yourdomain.com  
  SMTP relay host: postfix:2525  
  `echo "test" | mail -s "test from another container" abc@yourdomain.com` (or root)

- Issues? https://github.com/proofofgeek/docker-postfix

- Notes and random thoughts:
  - automagically configure docker networking
  - switch to alpine base?  
  - better way to build without .env?