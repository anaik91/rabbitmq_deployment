from retry import retry
import pika
from pika.exceptions import AMQPConnectionError,ConnectionWrongStateError,ConnectionClosedByBroker

connection = pika.BlockingConnection(pika.ConnectionParameters(host='52.236.19.78'))

def callback(ch, method, properties, body):
    print(" [x] Received {}".format(body))


@retry((AMQPConnectionError,ConnectionWrongStateError), delay=5, jitter=(1, 3))
def consume():
    channel = connection.channel()
    channel.basic_consume('quorum', callback)
    try:
        channel.start_consuming()
    except ConnectionClosedByBroker:
        print('ConnectionClosedByBroker')
        pass

if __name__ == '__main__':
    consume()