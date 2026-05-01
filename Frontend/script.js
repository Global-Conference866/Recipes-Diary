function showPage(pageId, element) {
    // 1. Hide all pages
    const pages = document.querySelectorAll('.page');
    pages.forEach(page => page.classList.remove('active-page'));

    // 2. Show the selected page
    document.getElementById(pageId).classList.add('active-page');

    // 3. Update Nav UI
    const navItems = document.querySelectorAll('.nav-item');
    navItems.forEach(item => item.classList.remove('active'));
    element.classList.add('active');
}
function saveRecipe() {
    const name = document.querySelector('.input-field').value;

    if(name) {
        alert('Recipe has been saved!');
    }
}
async function displayRecipes() {
    try{
        const response = await fetch('Backend/getrecipes.php');
        const recipes = await response.json();

        const trendingGrid = document.querySelector('.recipe-grid');
        const recommendedGrid = document.querySelector('.recipe-grid-lg');

        trendingGrid.innerHTML='';
        recommendedGrid.innerHTML='';

        recipes.forEach(recipe => {
    const card = `
        <div class="recipe-card" onclick="openRecipe(${recipe.id})">
            <img src="${recipe.img_url || 'default.jpg'}" />
            <h3>${recipe.title}</h3>
            <p>${recipe.category || 'No category'}</p>
        </div>
    `;

    if (recipe.isTrending == 1) {
        trendingGrid.innerHTML += card;
    }

    if (recipe.isRecommended == 1) {
        recommendedGrid.innerHTML += card;
    }
});
    } catch (error) {
        console.error("Error fetching recipes:", error);
    }  
}
window.onload=displayRecipes;
async function saveRecipe(){
    const name = document.getElementById('recipeName').value;
    const desc = document.getElementById('recipeDesc').value;
    const instr = document.getElementById('recipeInstr').value;
    const fileInput = document.getElementById('fileInput');

    if(!name || !desc || !instr){
        alert("Please fill in all fields!");
        return;
    }
    const formData = new FormData();
    formData.append('title', name);
    formData.append('description', desc);
    formData.append('instructions', instr);
    formData.append('recipe_image', fileInput.files[0]);

    try {
        const response = await fetch('Backend/saverecipes.php', {
            method: 'POST',
            body: formData
        })
        const result = await response.text();
        alert(result);
        location.reload();
    } catch(error){
        console.error("Error saving recipe:", error);
    }
}