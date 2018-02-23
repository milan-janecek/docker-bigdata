import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.TableName;
import org.apache.hadoop.hbase.client.*;

public class ConnectingExample {
  public static void main(String[] args) throws Exception {
    Configuration conf = Utils.createConfiguration();
    try (
      Connection connection = ConnectionFactory.createConnection(conf);
      Table hbaseMeta = connection.getTable(TableName.valueOf("hbase:meta"));
    ) {
      Scan scan = new Scan();
      ResultScanner rScanner = hbaseMeta.getScanner(scan);
      for (Result result: rScanner) {
        System.out.println(result);
      }
    }
  }
}
