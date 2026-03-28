class ListFormater {
  static addEndingPeriod(List<String> items) {
    return items.map((c) => c.trim().endsWith('.') ? c.trim() : '${c.trim()}.').join('\n');
  }
}