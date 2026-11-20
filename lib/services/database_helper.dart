  Future<List<Map<String, dynamic>>> getMonthlyCategorySummary(
    String type,
  ) async {
    final db = await database;

    final DateTime now = DateTime.now();

    final String monthStart =
        '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-01';

    final DateTime nextMonth = DateTime(
      now.year,
      now.month + 1,
      1,
    );

    final String nextMonthStart =
        '${nextMonth.year.toString().padLeft(4, '0')}-'
        '${nextMonth.month.toString().padLeft(2, '0')}-01';

    final List<Map<String, dynamic>> result =
        await db.rawQuery(
      '''
      SELECT
        c.name AS categoryName,
        SUM(t.amount) AS totalAmount
      FROM transactions t
      LEFT JOIN categories c
        ON t.categoryId = c.id
      WHERE t.type = ?
        AND t.date >= ?
        AND t.date < ?
      GROUP BY t.categoryId, c.name
      ORDER BY totalAmount DESC
      ''',
      [
        type,
        monthStart,
        nextMonthStart,
      ],
    );

    return result;
  }
