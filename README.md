# Linux System Administration Lab

## 🎯 Objective

This project demonstrates practical, security-aware Linux system administration skills aligned with the responsibilities of a Junior System Administrator in a DoD or federal environment. All tasks simulate real-world use cases, with an emphasis on automation, permission control, and STIG-compliant user management.

I am actively pursuing a Linux sysadmin role at Hill Air Force Base and built this lab to prove my capabilities in a clear, functional, and testable way.

---

## 🔧 Project: `create_users.sh`

A secure Bash script to automate the onboarding of new users.

### 🛠️ Features
- Accepts CLI arguments: `--admin` flag and username
- Validates input and handles incorrect usage cleanly
- Creates a local user account with home directory
- Sets a predictable but configurable default password (`CompanyYYYY`)
- **Forces password change on first login**
- **Applies password aging policy**:
  - Max age: 90 days
  - Min age: 7 days
  - Warning: 14 days before expiry
- Optionally adds the user to a pre-authorized admin group (`admin-team`) with sudo access

### 💡 Skills Used

- User and group management (`useradd`, `groupadd`, `usermod`)
- Secure password handling with `chpasswd` and `chage`
- Input validation and conditional logic with `case`, `[[ ]]`
- Group-based sudo access via `/etc/sudoers`

---


