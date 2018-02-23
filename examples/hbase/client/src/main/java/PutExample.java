import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.TableName;
import org.apache.hadoop.hbase.client.*;
import org.apache.hadoop.hbase.util.Bytes;

public class PutExample {
  public static void main(String[] args) throws Exception {
    Configuration conf = Utils.createConfiguration();
    try (
      Connection connection = ConnectionFactory.createConnection(conf);
      Table hbaseMeta = connection.getTable(TableName.valueOf("default:testtable"));
    ) {
      Put put = new Put(Bytes.toBytes());
    }
  }
}
