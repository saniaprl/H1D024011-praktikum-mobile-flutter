class Queue {
  List<int> data = [];

  void enqueue(int nilai) {
    data.add(nilai);
  }

  int? dequeue() {
    if (data.isEmpty) {
      print("Queue kosong");
      return null;
    }

    return data.removeAt(0);
  }
}

void main() {
  Queue antrean = Queue();

  antrean.enqueue(10);
  antrean.enqueue(20);
  antrean.enqueue(30);

  print("Isi Queue: ${antrean.data}");

  print("Data keluar: ${antrean.dequeue()}");
  print("Isi Queue sekarang: ${antrean.data}");
}