<%@ tag description="Main template for refine results menu for mobile"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_v1:js_template id="refine-results-template">
    <section data-panel="1" class="current">
        <span style="font-size: 16px;">Discounts</span>
        <field_v2:checkbox
                xpath="health_refine_results_discount"
                className="refine-results-discount"
                value="Y"
                required="true"
                label="${true}"
                title="Apply all available discounts to show me the lowest possible price"
        />

        <span style="font-size: 16px;">Rebate</span>
        <field_v2:checkbox
                xpath="health_refine_results_rebate"
                className="refine-results-rebate"
                value="Y"
                required="true"
                label="${true}"
                title="Apply the Australian Government Rebate to lower my upfront premium"
        />

        <div>
            <div>
                <p>
                    <h5 data-slide-panel="Hospital preferences">Hospital insurance preferences <span class="icon icon-angle-right"></span></h5>
                </p>
            </div>
        </div>

        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin congue ipsum a risus sagittis, nec luctus felis tristique. Duis sagittis consequat nisl ut consequat. Phasellus urna lacus, commodo in pharetra eu, ultrices id libero. Pellentesque porta tortor ut turpis pulvinar, in viverra tortor consequat. Sed nec consequat est. Pellentesque elit massa, suscipit at euismod sed, pretium sed felis. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus eget ante vestibulum, facilisis nisi a, consequat metus. Etiam scelerisque varius condimentum. Aenean sodales erat molestie posuere imperdiet. Etiam tempor vel augue eget iaculis. Aliquam lobortis tellus ac ex malesuada ornare. Integer vel condimentum justo. Maecenas mauris nulla, elementum sed mauris eget, egestas posuere quam.</p>

        <p>In viverra urna leo, nec vehicula nulla hendrerit quis. Duis eget nibh non metus vehicula feugiat non nec nisl. Quisque non rutrum massa, quis interdum eros. Nunc sodales leo urna, eget facilisis sapien efficitur at. Suspendisse viverra est eget nisl lacinia consectetur. Suspendisse accumsan ligula quis iaculis vestibulum. Curabitur ac eleifend ipsum. Aenean vitae sapien tristique, tincidunt urna vel, aliquam lectus. Suspendisse elit mi, malesuada at elementum ut, suscipit ac diam. In malesuada quam vitae ultrices egestas.</p>

        <p>Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Fusce ut auctor orci, quis egestas nisl. Pellentesque nec euismod risus, quis finibus dui. Sed venenatis est quis orci vehicula congue. Morbi malesuada et dolor eget tristique. Suspendisse egestas massa imperdiet nisl semper, vel cursus metus pharetra. Nam porttitor semper orci, eu eleifend metus condimentum ac. Suspendisse laoreet urna velit, sit amet pharetra purus ultricies ut. Donec non arcu maximus, vulputate ipsum ut, aliquet diam. Proin et luctus augue. Praesent ac efficitur tellus. Suspendisse vel dignissim magna, at feugiat felis.</p>
    </section>

    <section data-panel="Hospital preferences">
        Hospital Preferences

        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin congue ipsum a risus sagittis, nec luctus felis tristique. Duis sagittis consequat nisl ut consequat. Phasellus urna lacus, commodo in pharetra eu, ultrices id libero. Pellentesque porta tortor ut turpis pulvinar, in viverra tortor consequat. Sed nec consequat est. Pellentesque elit massa, suscipit at euismod sed, pretium sed felis. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus eget ante vestibulum, facilisis nisi a, consequat metus. Etiam scelerisque varius condimentum. Aenean sodales erat molestie posuere imperdiet. Etiam tempor vel augue eget iaculis. Aliquam lobortis tellus ac ex malesuada ornare. Integer vel condimentum justo. Maecenas mauris nulla, elementum sed mauris eget, egestas posuere quam.</p>

        <p>In viverra urna leo, nec vehicula nulla hendrerit quis. Duis eget nibh non metus vehicula feugiat non nec nisl. Quisque non rutrum massa, quis interdum eros. Nunc sodales leo urna, eget facilisis sapien efficitur at. Suspendisse viverra est eget nisl lacinia consectetur. Suspendisse accumsan ligula quis iaculis vestibulum. Curabitur ac eleifend ipsum. Aenean vitae sapien tristique, tincidunt urna vel, aliquam lectus. Suspendisse elit mi, malesuada at elementum ut, suscipit ac diam. In malesuada quam vitae ultrices egestas.</p>

        <p>Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Fusce ut auctor orci, quis egestas nisl. Pellentesque nec euismod risus, quis finibus dui. Sed venenatis est quis orci vehicula congue. Morbi malesuada et dolor eget tristique. Suspendisse egestas massa imperdiet nisl semper, vel cursus metus pharetra. Nam porttitor semper orci, eu eleifend metus condimentum ac. Suspendisse laoreet urna velit, sit amet pharetra purus ultricies ut. Donec non arcu maximus, vulputate ipsum ut, aliquet diam. Proin et luctus augue. Praesent ac efficitur tellus. Suspendisse vel dignissim magna, at feugiat felis.</p>

    </section>
</core_v1:js_template>