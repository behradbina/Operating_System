# 🚀 xv6 Operating System Optimization  

xv6 is a modern re-implementation of Unix Version 6 (v6), originally designed by **Dennis Ritchie** and **Ken Thompson**. While xv6 preserves the simplicity of its ancestor, our goal in this project was to **enhance and optimize its functionality** to create a more efficient and user-friendly version.  

Over **five development phases**, we introduced new features, improved scheduling, and enhanced the console experience.  

---

## 🔥 **Project Phases and Enhancements**  

### 🏗 **Phase 1: Enhanced Console Functionality**  
In this phase, we focused on improving **console usability and command-line interaction** by adding:  

✅ **Cursor Movement with Arrow Keys**  
- Users can now move the cursor **left (`←`) and right (`→`)** within their input without deleting characters.  

✅ **Command History Support**  
- Stores the last **10 commands**, allowing users to **navigate them using `↑` and `↓` arrow keys**.  

✅ **Copy-Paste Functionality**  
- **Ctrl+S**: Saves the current input.  
- **Ctrl+F**: Pastes the saved input back into the console.  

✅ **Smart Numeric Expression Handling**  
- If a numeric expression contains a **pattern like `N=NON`**, it gets transformed accordingly.  
  - Example: `a2+3=5?` → `a5b`  

---

### 🛠 **Phase 2: Adding New System Calls**  
This phase focused on **expanding the functionality of xv6** by introducing **five new system calls**:  

🔹 **1. `void create_palindrome(int num)`**  
- Generates the **palindrome version** of an input number.  
- Example:  
  - Input: `123`  
  - Output: `321`  

🔹 **2. `int move_file(const char* src_file, const char* dest_dir)`**  
- Moves a file to a specified directory.  
- **Returns**:  
  - `0` on success ✅  
  - `-1` on failure ❌  

🔹 **3. `int sort_syscalls(int pid)`**  
- Sorts all the **system calls invoked by a process** in ascending order.  

🔹 **4. `int get_most_invoked_syscall(int pid)`**  
- Returns the **most frequently called system call** by a given process.  

🔹 **5. `int list_all_processes()`**  
- Lists **all active processes** in the system.  

This phase significantly enhances **file management, system monitoring, and debugging capabilities** in xv6.  

---

### ⚡ **Phase 3: Optimization of Scheduling Algorithm (TBD)**  

### ✂️ **Phase 4: TBD**  

### 🔢 **Phase 5: TBD**  

---

## 🛠 **Contributors**  
This project was developed with passion and dedication by:  
- **Mehrad Livian**  
- **Marzieh Mousavi**  

---

## 🚀 **Building and Running xv6**  
To build xv6 on an x86 ELF-compatible system (such as Linux or FreeBSD), simply run:  

```bash
make
```
For non-x86 or non-ELF systems (such as macOS), you may need to install an **x86 cross-compiler**. Use the following command:  

```bash
make TOOLPREFIX=i386-jos-elf-
```
Then, install **QEMU** (a PC simulator) and run:  

```bash
make qemu
```
