# 🚀 Karwaan

Karwaan is a modern collaborative task management platform inspired by Trello.
It helps teams and individuals organize work with workspaces, boards, tasks, checklists, and comments — all built on a scalable full-stack architecture using Flutter (frontend) and Serverpod + PostgreSQL (backend).

---

# ✨ Features

| Category              | Highlights                                                                                                                                                            |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Auth**              | 🔐 JWT Authentication • Email & Password • Token Refresh • Secure Sessions                                                                                             |
| **User Profile**      | 👤 Profile Creation/Edit • Profile Pictures • Roles & Permissions                                                                                                      |
| **Tasks / Workspace** | ✅ Workspaces, Boards, Columns, Cards • Labels & Comments • Checklists & Checklist Items                                                                               |
| **Notifications**     | 🔔 Planned: Push & Local Notifications • Reminders • Alerts                                                                                                            |
| **Database**          | 🗄️ PostgreSQL via Serverpod ORM • Connected with pgAdmin 4 • Docker Support • Relations & Migrations                                                                   |
| **API / Client**      | ⚡ Auto-generated Client (`karwaan_client`) • Strongly Typed • REST & RPC                                                                                              |
| **UI / UX**           | 🎨 Flutter UI with Clean Navigation • Dark/Light Mode • Responsive Layout coming soon                                                                                  |
| **Architecture**      | 🏗️ Clean Flutter Architecture • Core (services, errors, themes) • Data (mappers, repositories) • Domain (models, repositories) • Presentation (cubits, pages, widgets) |
| **Dev Tools**         | ⚡ Server endpoints tested • Logging • CI/CD ready • Flutter frontend testing planned                                                                                  |

---

## 🧪 Testing Status

**Server endpoints are fully tested**  
🔜 Frontend testing coming in next release • Manual verification recommended

---

# 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)  
- [Dart SDK](https://dart.dev/get-dart)  
- [Serverpod CLI](https://docs.serverpod.dev)  
- PostgreSQL (local or Docker instance)  
- Android Studio or Visual Studio Code  

### 🛠️ Installation

1. **Clone & navigate**

    ```
    git clone https://github.com/Misbah313/Karwaan.git
    ```

    ```
    cd Karwaan
    ```

2. **Server Setup**

    ```
    cd karwaan_server
    ```

    ```
    dart pub get
    ```

    ```
    serverpod generate
    ```

    ```
    dart bin/main.dart
    ```

3. **Flutter App Setup**

    ```
    cd karwaan_flutter
    ```

    ```
    flutter pub get
    ```

    ```
    flutter run
    ```

---

# 📂 Project Structure

      karwaan/
      ├── 📂 .github/               # GitHub workflows, CI/CD
      ├── 📂 karwaan_client/        # Auto-generated client from Serverpod
      ├── 📂 karwaan_flutter/       # Flutter frontend app
      │   ├── 📂 lib/
      │   │   ├── 📂 core/          # Services, errors, themes
      │   │   ├── 📂 data/          # Mappers, repositories
      │   │   ├── 📂 domain/        # Models, repositories
      │   │   └── 📂 presentation/  # Cubits, pages, widgets
      │   └── main.dart             # App entry
      ├── 📂 karwaan_server/        # Serverpod backend
      └── 📄 README.md              # Root README

---

## 📸 UI/UX

<div align="center">

### **Authentication**
<img src="karwaan_flutter/screenshots/auth.png" width="80%">

### **Dashboard**
<img src="karwaan_flutter/screenshots/dash.png" width="80%">

### **Columns & cards**
<img src="karwaan_flutter/screenshots/columns.png" width="80%">

### **Dark Theme**
<img src="karwaan_flutter/screenshots/darks.png" width="80%">

</div>


---

# 🙌Contributions

 We welcome contributions! Follow these steps:

  1. **Fork the repo**
  2. **Create a Branch:**
     ```
     git checkout -b feat/your-feature
     ```

  3. **Commit your changes:**
     ```
     git commit -m "Add feature"
     ```

  4. **Push your branch:**
     ```
     git push origin feat/your-feature
     ```
  
  5. **Open a PR and with a clear description**

  
Guidelines:
   
   - Discuss major changes via Issues first.
   - Follow Clean Code practices.

   ---
 
# 📜License

  Distributed under MIT License.
  See [MIT License](LICENSE) for Details.

  ---

 🔗 Connect

    👤 Misbah 
    📧 [misbahgholami63@gmail.com](mailto:misbahgholami63@gmail.com)
    
  ---    

            ✨ Happy Coding! ✨ 









