import org.apache.spark.sql.{Dataset, SparkSession}

object SparkWordCount {
  def main(args: Array[String]) {
    // args(0) - input directory
    // args(1) - output directory

    val spark =
      SparkSession.builder.appName("SparkWordCount").getOrCreate()

    import spark.implicits._

    val lines = spark.read.textFile(args(0)).cache()

    val reduceFunc =
      (wordCountA: (String, Int), wordCountB: (String, Int)) => {
        assert(wordCountA._1 == wordCountB._1)
        (wordCountA._1, wordCountA._2 + wordCountB._2)
      }

    val singleWordCounts: Dataset[(String, Int)] = lines.flatMap(
      _.split(" ").map(word => (word, 1))
    )

    val wordCountsInPartitions: Dataset[(String, Int)] =
      singleWordCounts.mapPartitions(
        _.toArray
          .groupBy(_._1)
          .mapValues(_.reduce(reduceFunc))
          .values
          .toIterator
      )

    val wordCounts: Dataset[(String, Int)] = wordCountsInPartitions
      .groupByKey(_._1)
      .reduceGroups(reduceFunc)
      .map(_._2)

    wordCounts.map(_.toString()).repartition(1).write.text(args(1))

    spark.stop()
  }
}
