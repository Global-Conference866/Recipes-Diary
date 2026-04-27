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
        const response = await fetch('getrecipes.php');
        const recipes = await response.json();

        const trendingGrid = document.querySelector('.recipe-grid');
        const recommendedGrid = document.querySelector('.recipe-grid-lg');

        trendingGrid.innerHTML='';
        recommendedGrid.innerHTML='';

        recipes.forEach(recipe => {
            const cardHTML = `
                <div class="card-sm" onclick="openRecipe(${recipe.id})">
                    <div class="img-placeholder" style="background-image: url('${recipe.img_url}'); background-size: cover;"></div>
                    <div class="text-lines">
                        <strong>${recipe.title}</strong>
                        <span>${recipe.category}</span>
                    </div>
                </div>
            `;
            if (recipe.isTrending=="1"){
                trendingGrid.innerHTML += cardHTML;
            }
            if (recipe.isRecommended=="1"){
                recommendedGrid.innerHTML += cardHTML;
            }
        })
    } catch (error){
        console.error("Could not load recipes:", error);
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
        const response = await fetch('save_recipe.php', {
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