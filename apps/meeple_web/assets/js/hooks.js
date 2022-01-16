const Hooks = {};

Hooks.FieldCard = {
  mounted() {
    this.handleEvent("map_changed", (data) => {
      console.log(`map changed, fog_of_war: ${data.fog_of_war}`);
      this.el.dispatchEvent(new CustomEvent("close", { bubbles: true }));
    });
  },
};

export default Hooks;
