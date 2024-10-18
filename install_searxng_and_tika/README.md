
## SearXNG Installatioin
1. Run this commands in shell
[searxng docker](https://docs.searxng.org/admin/installation-docker.html)
``` shell
#this compose file will install Valkey. It's an open-source alternative to Redis.
docker-compose -f ./searxng_compose.yaml up -d

```
2. Using brwoser to visit the url http://{your_ip_address}:7777 then will see a search engine:
<table>
  <tboty>
    <tr>
      <td><img src="https://github.com/Kafkakav/how-to-start/blob/main/pics/searxng01.jpg" width="400" height="400"></td>
      <td><img src="https://github.com/Kafkakav/how-to-start/blob/main/pics/searxng02.jpg" width="400" height="400"></td>

    </tr>
  </tboty>
</table> 


## Apache tika Installation
1.  [Apache Tika Server Docker](https://hub.docker.com/r/apache/tika)
``` shell
docker-compose -f ./tika_compose.yaml up -d

```
2. Using brwoser to visit the url http://{your_ip_address}:9998 then will see a welcome page:
<table>
  <tboty>
    <tr>
      <td colspan="2"><img src="https://github.com/Kafkakav/how-to-start/blob/main/pics/tika01.jpg" width="400"    height="400"></td>
    </tr>
  </tboty>
</table> 

## Configration of Ollan Open WebUI (TBD)
1. For searxng: Admin-Pannel -> settings -> Web Search
2. For tika: Admin-Pannel -> settings -> Documents

