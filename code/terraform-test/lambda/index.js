const ENV = process.env
if (!ENV.webhook) throw new Error('Missing environment variable: webhook')

const webhook = ENV.webhook;
const https = require('https')

exports.handler = async (event) => {
    await exports.processEvent(event);
}

exports.processEvent = async (event) => {
    console.log('Event:', JSON.stringify(event))
    const snsMessage = event.Records[0].Sns.Message;
    console.log('SNS Message:', snsMessage);
    const postData = exports.buildDiscordMessage(JSON.parse(snsMessage))
    await exports.postDiscord(postData, webhook);
}

exports.buildDiscordMessage = (data) => {
    console.log('DATA:', data);
    const eventSource = data["Event Source"];
    const eventTime = data["Event Time"].split(".")[0];
    const sourceId = data["Source ID"];
    const eventMessage = data["Event Message"];
        
    return {
        embeds: [
            {
                title: `[${eventMessage}]`,
                color: 16753920, // 주황색 (Discord는 10진수 컬러 코드)
                fields: [
                    {
                        name: '이벤트 소스',
                        value: eventSource || 'N/A',
                        inline: false
                    },
                    {
                        name: '이벤트 시간',
                        value: exports.toYyyymmddhhmmss(eventTime),
                        inline: false
                    },
                    {
                        name: '소스 아이디',
                        value: sourceId || 'N/A',
                        inline: false
                    },
                    {
                        name: '메시지',
                        value: eventMessage || 'N/A',
                        inline: false
                    },
                    {
                        name: '데이터베이스 목록',
                        value: '[클릭 후 DB 상태 확인 가능](https://ap-northeast-2.console.aws.amazon.com/rds/home?region=ap-northeast-2#databases:)',
                        inline: false
                    },
                    {
                        name: '데이터베이스 이벤트로그',
                        value: '[클릭 후 로그와 이벤트 확인 가능](https://ap-northeast-2.console.aws.amazon.com/rds/home?region=ap-northeast-2#event-list:)',
                        inline: false
                    }
                ]
            }
        ]
    }
}

// 타임존 UTC -> KST
exports.toYyyymmddhhmmss = (timeString) => {

    if(!timeString){
        return '';
    }

    const kstDate = new Date(new Date(timeString).getTime() + 32400000);

    function pad2(n) { return n < 10 ? '0' + n : n }

    return kstDate.getFullYear().toString()
        + '-'+ pad2(kstDate.getMonth() + 1)
        + '-'+ pad2(kstDate.getDate())
        + ' '+ pad2(kstDate.getHours())
        + ':'+ pad2(kstDate.getMinutes())
        + ':'+ pad2(kstDate.getSeconds());
}

exports.postDiscord = async (message, DiscordUrl) => {
    return await request(exports.options(DiscordUrl), message);
}

exports.options = (DiscordUrl) => {
    const {host, pathname} = new URL(DiscordUrl);
    return {
        hostname: host,
        path: pathname,
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
    };
}

function request(options, data) {

    return new Promise((resolve, reject) => {
        const req = https.request(options, (res) => {
            res.setEncoding('utf8');
            let responseBody = '';

            res.on('data', (chunk) => {
                responseBody += chunk;
            });

            res.on('end', () => {
                resolve(responseBody);
            });
        });

        req.on('error', (err) => {
            console.error(err);
            reject(err);
        });

        req.write(JSON.stringify(data));
        req.end();
    });
}