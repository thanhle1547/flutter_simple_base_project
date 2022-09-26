# flutter_simple_base_project

Base cơ bản cho dự án Flutter.

## Cấu trúc thư mục

- Tất cả các file/thư mục được đặt tên theo kiểu `snake_case`

> [Guideline](https://github.com/thanhle1547/flutter_architecture_notes/tree/main/proposed_simple_scalable)

## Naming Convention

> 1. [Effective Dart: Style](https://dart.dev/guides/language/effective-dart/style)
>
> 2. [Flutter: Best Practices and Tips](https://medium.com/flutter-community/flutter-best-practices-and-tips-7c2782c9ebb5)

## Note

Concept được trình bày dưới đây là đề xuất của cá nhân và

> Đây không phải là best practices

Để giảm số lần viết code cập nhật dữ liệu từ tương tác của người dùng, ví dụ:

- Cập nhật dữ liệu người dùng nhập vào TextField (thông qua hàm onChanged).

- Thay đổi trạng thái của nút like (thông qua một custom callback).

- Hiển thị thông tin (dữ liệu) mà người dùng chọn trên chính button đã ấn vào (ví dụ: thông qua hàm onChanged của DropdownButton).

- ...

Ý tưởng đưa ra: Mỗi widget **(trực tiếp)** nhận và xử lý tương tác của người dùng sẽ đảm nhận trách nhiệm cập nhật kết quả vào ValueListenable, *Subject (ReactiveX)... Các widget đó cũng sẽ theo dõi/lắng nghe thông báo dữ liệu đã thay đổi và cập nhật lại giao diện (rebuild/setState).

Ví dụ trong base project này là widget `CustomTextFormField` (file [`custom_text_form_field.dart`](./lib/common/widgets/forms/custom_text_form_field.dart)) có một trường tên là `data` kiểu `ValueNotifier`.

