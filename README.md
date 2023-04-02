# OpenAI-Checker
Used to check if your IP can access OpenAI services.

# My Modifications - by spiritlhl

Increase the timeout limit for requests

Add error handling to avoid error output

Change IPV4 and IPV6 check methods

```
bash <(curl -Ls https://bash.spiritlhl.net/openai-checker)
```

or

```
bash <(curl -Ls https://raw.githubusercontent.com/spiritLHLS/OpenAI-Checker/main/openai.sh)
```

**The following descriptions are from the original repo**

## Notice
**I have only created this script, and any other websites and programs for OpenAI service availability checking are not my responsibility, so please judge the accuracy by yourself. Theoretically, it is not possible to make accurate judgments through the web side, so it is recommended that you do so through a shell.**

## Detection method
Our detection results come from **Cloudflare** and the accuracy is independent of this script.   

At present, there are 161 countries supported, and I will continue to update the countries and regions newly supported by OpenAI.

## Usage
```shell
bash <(curl -Ls https://cpp.li/openai)
```
or
```shell
bash <(curl -Ls https://cdn.jsdelivr.net/gh/missuo/OpenAI-Checker/openai.sh)
```
## Result
```
> bash <(curl -Ls https://cpp.li/openai)
OpenAI Access Checker. Made by Vincent
https://github.com/missuo/OpenAI-Checker
-------------------------------------
[IPv4]
Your IPv4: 205.185.1.1 - FranTech Solutions
Your IP supports access to OpenAI. Region: US
-------------------------------------
[IPv6]
Your IPv6: 2401:95c0:f001::1 - Vincent Yang
Your IP supports access to OpenAI. Region: TW
-------------------------------------
```
## Thanks
- [Hill-98](https://github.com/Hill-98): Improved the Loc Code that can support access to OpenAI. [#1](https://github.com/missuo/OpenAI-Checker/issues/1)

## Author
**OpenAI-Checker** © [Vincent Young](https://github.com/missuo), Released under the [MIT](./LICENSE) License.<br>
