document.addEventListener("DOMContentLoaded", function () {
    fetch("/tasks")
    .then((response) => response.json())
    .then((tasks) => {
        const taskList = document.getElementById("task-list");
        tasks.forEach((task) => {
            const li = document.createElement("li");
            li.innerHTML = `<strong>${task.title}</strong><br>
                            ${task.contents}<br>
                            등록일:${task.input_date}<br>
                            마감일:${task.due_date}`;
            
            // Create a container for the links
            const linkContainer = document.createElement("div");
            linkContainer.className = "link-container";

            // Create and append the edit link
            const editLink = document.createElement("a");
            editLink.href = `/edit/${task.id}`;
            editLink.textContent = "Edit";
            editLink.className = "edit";
            linkContainer.appendChild(editLink);

            // Create and append the delete link
            const deleteLink = document.createElement("a");
            deleteLink.href = `/delete/${task.id}`;
            deleteLink.textContent = 'Delete';
            deleteLink.className = "delete";
            linkContainer.appendChild(deleteLink);

            // Append the link container to the list item
            li.appendChild(linkContainer);
            taskList.appendChild(li);
        });
    });
});
